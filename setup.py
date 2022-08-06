#!/usr/bin/env python3

import argparse
import ctypes
import platform
import shutil
import subprocess as sp
import sys
from datetime import datetime
from pathlib import Path
from typing import Union

LINUX = "Linux"
WINDOWS = "Windows"


class UnsupportedOS(Exception):
    ...


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
                self.vprint(3, f"Backing up: {dst} -> {self.backup / src}")
                shutil.copy(dst, self.backup / src)

            self.vprint(3, f"Removing: {dst}")
            dst.unlink()

        if self.remove:
            return  # Only remove the links

        src = src.resolve()
        self.vprint(1, f"Symlinking: {dst} -> {src}")
        dst.symlink_to(src)

    def setup_linux(self):
        # Backing up files
        for file in self.dotfiles.glob("**/*"):
            if not set(file.parts).isdisjoint(self.exclude):
                continue
            dest = Path.home() / Path(*file.parts[1:])
            if file.is_dir():
                self.vprint(2, f"Making Dir: {dest}")
                dest.mkdir(parents=True, exist_ok=True)
                continue
            # symlink with backup.
            self.symlink(file, dest)

    def setup_windows(self):
        if not ctypes.windll.shell32.IsUserAnAdmin():  # pyright: ignore
            print("Must be run as admin")
            sys.exit(1)

        p = sp.run(
            ["pwsh.exe", "-c", "$PROFILE"],
            capture_output=True,
            text=True,
        )
        profile = Path(p.stdout.strip())
        self.symlink(Path(f"powershell/{profile.name}"), profile)


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
            "Can be passed up to 3 times with increasing verbositiy."
        ),
    )
    args = parser.parse_args()
    Setup(**vars(args))
