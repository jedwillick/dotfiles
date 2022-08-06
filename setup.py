#!/usr/bin/env python3

import argparse
import ctypes
import platform
import shutil
import subprocess as sp
import sys
from datetime import datetime
from pathlib import Path

LINUX = "Linux"
WINDOWS = "Windows"


class Setup:
    DOTFILES = Path("dotfiles")

    def __init__(self, remove=False, exclude=[], backup=True):
        if backup:
            self.backup = Path(f"backup/{datetime.today():%d-%m-%Y_%H.%M.%S}")
        else:
            self.backup = None
        self.exclude = exclude
        self.remove = remove
        self.os = platform.system()
        if self.os == LINUX:
            self.setup_linux()
        elif self.os == WINDOWS:
            self.setup_windows()
        else:
            print(f"Unsupported OS {self.os}")
            sys.exit(1)

    def __str__(self):
        members = ", ".join(f"{k}={v}" for k, v in self.__dict__.items())
        return f"{self.__class__.__name__}({members})"

    def symlink(self, src, dst):
        if dst.exists():
            if self.backup:
                (self.backup / src.parent).mkdir(
                    parents=True,
                    exist_ok=True,
                )
                shutil.copy(dst, self.backup / src)
            dst.unlink()

        if self.remove:
            return  # Only remove the links

        dst.symlink_to(src.resolve())

    def setup_linux(self):
        # Backing up files
        for file in self.DOTFILES.glob("**/*"):
            if not set(file.parts).isdisjoint(self.exclude):
                continue
            dest = Path.home() / Path(*file.parts[1:])
            if file.is_dir():
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
        default=True,
        help="Backup old files",
    )
    args = parser.parse_args()
    Setup(**vars(args))
