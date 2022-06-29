#!/usr/bin/env python3

import platform
import shutil
import subprocess
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
                continue
            (BACK / f.parent).mkdir(parents=True, exist_ok=True)
            shutil.copy(old, BACK / f)
            old.unlink()

        # Symlinking dotfiles with stow
        subprocess.run(["stow", "-v", str(p)])


def setup_windows():
    ...


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
