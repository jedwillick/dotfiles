param (
    [string]$action
)

function WingetCmd([string]$package) {
    $out = winget upgrade --accept-package-agreements --accept-source-agreements $package
    $last = $out.Trim() -split '\r?\n' | Select-Object -Last 2
    if ($last | Select-String -Pattern "No installed package") {
        $out = winget install --accept-package-agreements --accept-source-agreements $package
        $last = $out.Trim() -split '\r?\n' | Select-Object -Last 2
    }
    Write-Host $package.PadRight(30) $last
}

function InstallWinget() {
    $PACKAGES = @(
        "Google.Chrome",
        "Git.Git",
        "Discord.Discord",
        "JanDeDobbeleer.OhMyPosh",
        "Microsoft.Office",
        "Microsoft.OneDrive",
        "Spotify.Spotify",
        "Zoom.Zoom",
        "Python.Python.3",
        "Microsoft.PowerToys",
        "Microsoft.VisualStudioCode",
        "NickeManarin.ScreenToGif",
        "Microsoft.WindowsTerminal.Preview",
        "Valve.Steam",
        "JetBrains.Toolbox",
        "Notepad++.Notepad++",
        "elvirbrk.notehighlight2016",
        "PuTTY.PuTTY",
        "Oracle.VirtualBox"
    )
    $funcDef = ${function:WingetCmd}.ToString()
    Write-Host "Installing winget packages..."
    $PACKAGES | Foreach-Object -ThrottleLimit 5 -Parallel {
        ${function:WingetCmd} = $using:funcDef
        WingetCmd $_
    }
}

function InstallPwsh () {
    Write-Host "Installing powershell..."
    WingetCmd "Microsoft.PowerShell"
}

function InstallPip() {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    Write-Host "Installing pip packages..."
    python -m pip install --upgrade pip
    pip install --upgrade -r pip-packages.txt
}

if ($null -eq (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Start-Process ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1
    Write-Error "winget must be installed" -ErrorAction Stop
}

Switch ($action) {
    "pwsh" {
        InstallPwsh
    }
    "winget" {
        InstallWinget
    }
    "pip" {
        InstallPip
    }
    "all" {
        InstallPwsh
        InstallWinget
        InstallPip
    }
    default {
        Write-Host "Usage: $(Split-Path $PSCommandPath -Leaf) [pwsh|winget|pip|all]"
    }
}
