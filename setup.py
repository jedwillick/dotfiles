#!/usr/bin/env python3

import ctypes
import platform
import shutil
import subprocess as sp
import sys
from datetime import datetime
from pathlib import Path


def setup_linux():
    if shutil.which("stow") is None:
        print("stow must be installed")
        BACK.rmdir()
        sys.exit(1)

    ignore = [".git", "backup", "fonts", "powershell"]
    paths = [p for p in Path(".").iterdir() if p.is_dir() and str(p) not in ignore]
    for p in paths:
        # Backing up files
        for f in p.glob("**/*"):
            if f.is_dir():
                continue
            old = Path.home() / Path(*f.parts[1:])

            if not old.exists():
                # Remove dangling symlinks
                if old.is_symlink():
                    old.unlink()
                continue

            (BACK / f.parent).mkdir(parents=True, exist_ok=True)
            shutil.copy(old, BACK / f)
            old.unlink()

        # Symlinking dotfiles with stow
        sp.run(["stow", "--no-folding", "-v", str(p)])


def setup_windows():
    if not ctypes.windll.shell32.IsUserAnAdmin():  # pyright: ignore
        print("Must be run as admin")
        BACK.rmdir()
        sys.exit(1)

    p = sp.run(
        ["pwsh.exe", "-c", "$PROFILE"],
        capture_output=True,
        text=True,
    )
    profile = Path(p.stdout.strip())
    if profile.exists():
        shutil.copy(profile, BACK / profile.name)
        profile.unlink()
    profile.symlink_to(Path(f"powershell/{profile.name}").resolve())


if __name__ == "__main__":
    BACK = Path(f"backup/{datetime.today():%d-%m-%Y_%H.%M.%S}")
    BACK.mkdir(parents=True)

    OS = platform.system()
    if OS == "Linux":
        setup_linux()
    elif OS == "Windows":
        setup_windows()
    else:
        print(f"Unknown OS {OS}")
        BACK.rmdir()
