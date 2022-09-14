#!/usr/bin/env python3

import argparse
import os
import platform
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import Union

LINUX = "Linux"
WINDOWS = "Windows"

V1 = 1
V2 = 2


class UnsupportedOS(Exception):
    ...


def check_symlink():
    with NamedTemporaryFile() as tmp1, NamedTemporaryFile() as tmp2:
        try:
            os.remove(tmp2.name)
            os.symlink(tmp1.name, tmp2.name)
        except OSError:
            print(
                "You do not have symlink permissions.\n"
                "Either run as admin or enable developer mode.",
            )
            sys.exit(1)
        finally:
            # This wasn't being done by the context manager
            os.remove(tmp2.name)


def dotfile_to_realpath(dotfile: Path):
    return Path.home() / Path(*dotfile.parts[1:])


class Setup:
    def __init__(
        self,
        dotfiles: Union[str, Path],
        link=True,
        force=False,
        backup=False,
        exclude=None,
        verbose=0,
    ):
        self.dotfiles = Path(dotfiles)
        if not self.dotfiles.exists() or not self.dotfiles.is_dir():
            raise NotADirectoryError(f"{self.dotfiles} is not a directory")

        self.backup = backup
        self.backupRoot = Path(f"backup/{datetime.today():%d-%m-%Y_%H.%M.%S}")
        self.exclude = exclude if exclude else []
        self.force = force
        self.link = link
        self.verbose = verbose
        self.os = platform.system()
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
            raise UnsupportedOS(f"{self.os} is not supported")

    def vprint(self, level: int, *args, **kwargs):
        if self.verbose >= level:
            print(*args, **kwargs)

    def backup_(self, src: Path):
        if not src.exists() or src.is_dir():
            return
        dst = self.backupRoot / src.relative_to(Path.home())
        dst.parent.mkdir(parents=True, exist_ok=True)
        self.vprint(V1, f"Backing up: {src} -> {dst}")
        shutil.copy(src, dst)

    def force_(self, target):
        if target.is_dir():
            return
        if target.exists() or target.is_symlink():
            self.vprint(V1, f"Removing: {target}")
            target.unlink()

    def link_(self, src, dst):
        src = src.resolve()
        self.vprint(V1, f"Symlinking: {dst} -> {src}")
        try:
            dst.symlink_to(src)
        except FileExistsError:
            print(
                f"{dst} already exists.",
                "If you want to overwrite it rerun with --force.",
                file=sys.stderr,
            )

    def mkdir(self, target):
        if not self.link:
            return
        if not target.exists():
            self.vprint(V1, f"Making Dir: {target}")
            target.mkdir(parents=True)

    def setup_dotfile(self, src, dst):
        if self.backup:
            self.backup_(dst)

        if self.force:
            self.force_(dst)

        if not dst.parent.is_dir():
            print(
                f"{dst.parent} is not a directory",
                "If you want to overwrite it rerun with --force.",
                file=sys.stderr,
            )
            return

        if src.is_dir():
            self.mkdir(dst)
            return

        if self.link:
            self.link_(src, dst)

    def setup_linux(self):
        # Backing up files
        for file in self.dotfiles.glob("**/*"):
            if not set(file.parts).isdisjoint(self.exclude):
                continue
            dest = dotfile_to_realpath(file)
            self.setup_dotfile(file, dest)

    def setup_windows(self):
        # Checking for symlink permissions
        check_symlink()

        p = subprocess.run(
            ["pwsh.exe", "-c", "$PROFILE"],
            capture_output=True,
            text=True,
        )
        profile = Path(p.stdout.strip())
        self.setup_dotfile(Path(f"powershell/{profile.name}"), profile)

        INCLUDE = (
            ".gitconfig",
            ".poshthemes",
            ".ssh",
            ".vimrc",
        )

        poshThemesPath = os.getenv("POSH_THEMES_PATH")
        poshThemesPath = Path(poshThemesPath) if poshThemesPath else None
        for file in self.dotfiles.glob("**/*"):
            parts = set(file.parts)
            if not parts.isdisjoint(self.exclude) or parts.isdisjoint(INCLUDE):
                continue

            if ".poshthemes" in parts:
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
        nargs="+",
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
            "Can be passed up to 2 times with increasing verbositiy."
        ),
    )
    parser.add_argument(
        "-c",
        "--clean",
        action="store_true",
        help="Clean up all backup files.",
    )

    args = parser.parse_args()
    if args.clean:
        shutil.rmtree("backup", ignore_errors=True)
        if args.verbose:
            print("Removed backups.")
        sys.exit(0)

    args = vars(args)
    args.pop("clean")
    Setup(**args)
