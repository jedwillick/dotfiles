import multiprocessing as mp
import shutil
import subprocess as sp
import sys


def winget_cmd(cmd, package):
    return sp.run(
        [
            "winget",
            cmd,
            "--accept-package-agreements",
            "--accept-source-agreements",
            "--silent",
            package,
        ],
        capture_output=True,
        text=True,
    )


def winget(package):
    # Try to upgrade existing packages first
    p = winget_cmd("upgrade", package)
    if "No installed package" in p.stdout:
        p = winget_cmd("install", package)

    if "Successfully installed" in p.stdout:
        # We dont want the loading bar or other information
        out = "Successfully installed"
    else:
        # Filter out escape codes that messes with output
        out = " ".join(word for word in p.stdout.split() if word.isalnum())

    print(f"{package:<30} {out}")
    return p.returncode


if __name__ == "__main__":
    if not shutil.which("winget"):
        print("winget must be installed manually")
        sp.run("start ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1", shell=True)
        sys.exit(1)

    PACKAGES = [
        "Google.Chrome",
        "Git.Git",
        "Discord.Discord",
        "JanDeDobbeleer.OhMyPosh",
        "Microsoft.Office",
        "Microsoft.OneDrive",
        "Spotify.Spotify",
        "Zoom.Zoom",
        "Python.Python.3",
        "Microsoft.PowerShell",
        "Microsoft.PowerToys",
        "Microsoft.VisualStudioCode",
        "NickeManarin.ScreenToGif",
        "Microsoft.WindowsTerminal.Preview",
        "Valve.Steam",
        "JetBrains.Toolbox",
    ]

    with mp.Pool() as p:
        retcode = sum(p.map(winget, PACKAGES))

    sys.exit(retcode)
