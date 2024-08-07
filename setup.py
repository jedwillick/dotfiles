#!/usr/bin/env python3

import argparse
import fnmatch
import os
import platform
import shutil
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import IO, Tuple, Union

LINUX = "Linux"
WINDOWS = "Windows"


@dataclass
class Log:
    DEBUG = 0
    LOWINFO = 1
    INFO = 2
    WARN = 3
    FATAL = 4
    UNSET = 99
    DEBUG_COLOR = "\033[1;39m"
    INFO_COLOR = "\033[1;34m"
    WARN_COLOR = "\033[1;33m"
    FATAL_COLOR = "\033[1;31m"
    RESET_COLOR = "\033[0m"
    ARROW_COLOR = "\033[1;35m"

    level: int = INFO
    colored: bool = True

    def levelToDetail(self, level: int) -> Tuple[str, str, IO]:
        if level == self.DEBUG:
            return ("[DEBUG] ", self.DEBUG_COLOR, sys.stderr)
        elif level == self.INFO or level == self.LOWINFO:
            return ("", self.INFO_COLOR, sys.stdout)
        elif level == self.WARN:
            return ("[WARN] ", self.WARN_COLOR, sys.stderr)
        elif level == self.FATAL:
            return ("[FATAL] ", self.FATAL_COLOR, sys.stderr)
        else:
            raise Exception(f"Unknown level {level}")

    def log(self, level: int, message, *, prefix: str = ""):
        if level < self.level:
            return
        levelPrefix, color, stream = self.levelToDetail(level)
        prefix = prefix + ":" if prefix else prefix
        color = color if self.colored else ""
        resetColor = self.RESET_COLOR if self.colored else ""
        if self.colored and isinstance(message, str):
            message = message.replace("->", f"{self.ARROW_COLOR}->{resetColor}")

        print(f"{color}{levelPrefix}{prefix}{resetColor}{message}", file=stream)

    def debug(self, message, **kwargs):
        self.log(self.DEBUG, message, **kwargs)

    def lowinfo(self, message, **kwargs):
        self.log(self.LOWINFO, message, **kwargs)

    def info(self, message, **kwargs):
        self.log(self.INFO, message, **kwargs)

    def warn(self, message, **kwargs):
        self.log(self.WARN, message, **kwargs)

    def fatal(self, message, exitCode: int = 1, **kwargs):
        self.log(self.FATAL, message, **kwargs)
        sys.exit(exitCode)


def check_symlink():
    with NamedTemporaryFile() as tmp1, NamedTemporaryFile() as tmp2:
        try:
            os.remove(tmp2.name)
            os.symlink(tmp1.name, tmp2.name)
        except OSError:
            log.fatal(
                "You do not have symlink permissions.\n"
                "Either run as admin or enable developer mode.",
                prefix="SYMLINK",
            )
        finally:
            # This wasn't being done by the context manager
            os.remove(tmp2.name)


def dotfile_to_realpath(dotfile: Path):
    parts = dotfile.parts
    if parts[-1].startswith("_wsl-"):
        if os.environ.get("WSL_DISTRO_NAME") is None:
            return None
        parts = parts[:-1] + (parts[-1].replace("_wsl-", ""),)
    dotfile = Path.home() / Path(*parts[1:])
    return dotfile.with_suffix("") if len(parts) > 1 and parts[-2] == "bin" else dotfile


class Setup:
    def __init__(
        self,
        dotfiles: Union[str, Path],
        link=True,
        force=False,
        backup=False,
        exclude=None,
        missing=False,
        **_,
    ):
        self.dotfiles = Path(dotfiles)
        if not self.dotfiles.exists() or not self.dotfiles.is_dir():
            log.fatal(f"{dotfiles} is not a directory", prefix="DOTFILES")
        self.backup = backup
        self.backupRoot = Path(f"backup/{datetime.today():%d-%m-%Y_%H.%M.%S}")
        self.exclude = exclude or []
        self.force = force
        self.link = link
        self.missing = missing
        self.os = platform.system()
        log.debug(self)
        self.setup()

    def __str__(self):
        members = ", ".join(f"{k}={v}" for k, v in self.__dict__.items())
        return f"{self.__class__.__name__}({members})"

    def setup(self):
        if self.os == LINUX:
            self.setup_linux()
        elif self.os == WINDOWS:
            self.setup_windows()
        else:
            log.fatal(f"{self.os} is not supported", prefix="OS")
        if self.backup and not self.missing:
            log.info(f"Created at {self.backupRoot}", prefix="BACKUP")

    def backup_(self, src: Path):
        if not src.exists() or src.is_dir():
            return
        dst = self.backupRoot / src.relative_to(Path.home())
        dst.parent.mkdir(parents=True, exist_ok=True)
        log.lowinfo(f"{src} -> {dst}", prefix="BACKUP")
        shutil.copy(src, dst)

    def force_(self, target):
        if target.is_dir():
            return
        if target.exists() or target.is_symlink():
            log.lowinfo(target, prefix="REMOVE")
            target.unlink()

    def link_(self, src, dst):
        src = src.resolve()
        prefix = "SYMLINK"
        try:
            dst.symlink_to(src)
            log.info(f"{dst} -> {src}", prefix=prefix)
        except FileExistsError:
            log.warn(f"{dst} already exists.", prefix=prefix)

    def mkdir(self, target):
        if not self.link:
            return
        if not target.exists():
            log.lowinfo(target, prefix="MKDIR")
            target.mkdir(parents=True)

    def is_excluded(self, path: Path):
        return any(fnmatch.fnmatch(str(path), exclude) for exclude in self.exclude)

    def setup_dotfile(self, src: Path, dst: Union[Path, None]):
        if dst is None or (self.missing and dst.exists()):
            log.debug(f"Skipping... {dst}", prefix="EXISTS")
            return

        if self.backup:
            self.backup_(dst)

        if self.force:
            self.force_(dst)

        if not dst.parent.is_dir():
            log.warn(f"{dst.parent} is not a directory")
            return

        if src.is_dir():
            self.mkdir(dst)
            return

        if self.link:
            self.link_(src, dst)

    def setup_linux(self):
        # Setting up dotfiles
        for file in self.dotfiles.glob("**/*"):
            if self.is_excluded(file):
                log.debug(f"Skipping... {file}", prefix="EXCLUDE")
                continue
            dest = dotfile_to_realpath(file)
            self.setup_dotfile(file, dest)
        if os.environ.get("WSL_DISTRO_NAME"):
            self.setup_wsl()
            return

    def setup_wsl(self):
        shims = [
            "/mnt/c/Windows/system32/cmd.exe",
            "/mnt/c/Program Files/PowerShell/7/pwsh.exe",
            "/mnt/c/Program Files/Docker/Docker/resources/bin/docker",
            "/mnt/c/Users/$WIN_USER/AppData/Local/Programs/Microsoft VS Code/bin/code",
            "/mnt/c/Users/$WIN_USER/AppData/Local/Microsoft/WindowsApps/wt.exe",
            "/mnt/c/Windows/system32/wsl.exe",
            "/mnt/c/Windows/explorer.exe",
            "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe",
            # oh-my-posh uses this to speed up access in windows directories
            "/mnt/c/Program Files/Git/cmd/git.exe",
            "git",
        ]
        for shim in shims:
            name = Path(shim).name
            dest = Path.home() / ".local/bin" / name
            src = Path("wsl-shims") / (name + ".sh")
            if not src.exists():
                src = Path("wsl-shims") / ("__" + name + ".sh")
                src.write_text(
                    f"#!/usr/bin/env sh\n"
                    f'exec "{shim}" "$@"\n'
                    f"# Autogenerated by {Path(__file__)}\n"
                )
                src.chmod(0o744)
            self.setup_dotfile(src, dest)

    def setup_windows(self):
        # Checking for symlink permissions
        check_symlink()

        p = subprocess.run(
            ["pwsh.exe", "-c", "$PROFILE"],
            capture_output=True,
            text=True,
        )
        profile = Path(p.stdout.strip())
        self.setup_dotfile(Path(f"windows/{profile.name}"), profile)

        windowsTerminal = Path(
            f'{os.getenv("LOCALAPPDATA")}'
            "/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe"
            "/LocalState/settings.json"
        )
        self.setup_dotfile(Path("windows/windows-terminal.json"), windowsTerminal)

        INCLUDE = (
            ".gitconfig",
            "poshthemes",
            ".ssh",
            ".vimrc",
        )

        poshThemesPath = os.getenv("POSH_THEMES_PATH")
        poshThemesPath = Path(poshThemesPath) if poshThemesPath else None
        for file in self.dotfiles.glob("**/*"):
            parts = set(file.parts)
            if self.is_excluded(file) or parts.isdisjoint(INCLUDE):
                continue

            if "poshthemes" in parts:
                if poshThemesPath is None:
                    continue
                dest = poshThemesPath if file.is_dir() else poshThemesPath / file.name
            else:
                dest = dotfile_to_realpath(file)
            self.setup_dotfile(file, dest)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Setup dotfiles")
    parser.add_argument(
        "dotfiles",
        nargs="?",
        type=Path,
        default="dotfiles",
        help="Directory containing the dotfiles. Default: %(default)s",
    )
    parser.add_argument(
        "-e",
        "--exclude",
        metavar="PATTERN",
        action="append",
        default=[],
        help="Exclude files/folders from setup",
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="Remove all existing files.",
    )
    parser.add_argument(
        "-m",
        "--missing",
        action="store_true",
        help="Only link missing files",
    )
    parser.add_argument(
        "--no-link",
        dest="link",
        action="store_false",
        help="Don't symlink the dotfiles. "
        "Useful if you just wish to backup or unlink them",
    )
    parser.add_argument(
        "--no-backup",
        dest="backup",
        action="store_false",
        help="Backup old files",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        default=0,
        action="count",
        help=(
            "Print verbose output. "
            "-v: Print LOWINFO messages. "
            "-vv: Print DEBUG messages."
        ),
    )
    parser.add_argument(
        "-q",
        "--quiet",
        default=0,
        action="count",
        help="Don't output anything. Only set exit codes.",
    )
    parser.add_argument(
        "-c",
        "--clean",
        action="store_true",
        help="Clean up all backup files.",
    )
    parser.add_argument(
        "--no-color",
        dest="color",
        action="store_false",
        help="Disable colored output",
    )

    args = parser.parse_args()
    level = Log.UNSET if args.quiet else Log.INFO - args.verbose
    log = Log(level, args.color)

    if args.clean:
        backup = Path("backup")
        numBackups = len(list(backup.iterdir())) if backup.exists() else 0
        shutil.rmtree("backup", ignore_errors=True)
        log.info(f"removed {numBackups} backups", prefix="BACKUP")
        sys.exit(0)

    args = vars(args)
    log.debug(f"{args=}")
    Setup(**args)
