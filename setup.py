#!/usr/bin/env python3

import argparse
import os
import platform
import shutil
import subprocess as sp
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
        os.remove(tmp2.name)
        try:
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
        remove=False,
        exclude=[],
        backup=False,
        verbose=0,
    ):
        self.dotfiles = Path(dotfiles)
        if not self.dotfiles.exists() or not self.dotfiles.is_dir():
            raise NotADirectoryError(f"{self.dotfiles} is not a directory")

        if backup:
            self.backup = Path(f"backup/{datetime.today():%d-%m-%Y_%H.%M.%S}")
        else:
            self.backup = None

        self.exclude = exclude
        self.remove = remove
        self.verbose = verbose

        self.os = platform.system()
        if self.os == LINUX:
            self.setup_linux()
        elif self.os == WINDOWS:
            self.setup_windows()
        else:
            raise UnsupportedOS(f"{self.os} is not supported")

    def __str__(self):
        members = ", ".join(f"{k}={v}" for k, v in self.__dict__.items())
        return f"{self.__class__.__name__}({members})"

    def vprint(self, level: int, *args, **kwargs):
        if self.verbose >= level:
            print(*args, **kwargs)

    def symlink(self, src, dst):
        if dst.exists():
            if self.backup:
                (self.backup / src.parent).mkdir(
                    parents=True,
                    exist_ok=True,
                )
                self.vprint(V2, f"Backing up: {dst} -> {self.backup / src}")
                shutil.copy(dst, self.backup / src)

            self.vprint(V1 if self.remove else V2, f"Removing: {dst}")
            dst.unlink()

        if self.remove:
            return  # Only remove the links

        src = src.resolve()
        self.vprint(V1, f"Symlinking: {dst} -> {src}")
        dst.symlink_to(src)

    def setup_linux(self):
        # Backing up files
        for file in self.dotfiles.glob("**/*"):
            if not set(file.parts).isdisjoint(self.exclude):
                continue
            dest = dotfile_to_realpath(file)
            if file.is_dir():
                self.vprint(V2, f"Making Dir: {dest}")
                dest.mkdir(parents=True, exist_ok=True)
                continue
            # symlink with backup.
            self.symlink(file, dest)

    def setup_windows(self):
        # Checking for symlink permissions
        check_symlink()

        p = sp.run(
            ["pwsh.exe", "-c", "$PROFILE"],
            capture_output=True,
            text=True,
        )
        profile = Path(p.stdout.strip())
        self.symlink(Path(f"powershell/{profile.name}"), profile)

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
            if file.is_dir():
                self.vprint(V2, f"Making Dir: {dest}")
                dest.mkdir(parents=True, exist_ok=True)
                continue

            self.symlink(file, dest)


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
        "-r",
        "--remove",
        action="store_true",
        help="Remove all links to the dotfiles instead of creating them",
    )
    parser.add_argument(
        "-b",
        "--backup",
        action="store_true",
        help="Backup old files",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        default=0,
        action="count",
        help=(
            "Print verbose output."
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
            print("Removed all backups.")
        sys.exit(0)

    args = vars(args)
    args.pop("clean")
    Setup(**args)
