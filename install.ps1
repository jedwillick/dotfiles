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

function InstallModules() {
    Install-Module PSReadLine -Force
    Install-Module PSFzf
    Install-Module posh-git
}

function InstallWinget() {
    $PACKAGES = @(
        "Discord.Discord",
        "Git.Git",
        "Google.Chrome",
        "JanDeDobbeleer.OhMyPosh",
        "JetBrains.Toolbox",
        "Microsoft.Office",
        "Microsoft.OneDrive",
        "Microsoft.PowerToys",
        "Microsoft.VisualStudioCode",
        "Microsoft.WindowsTerminal.Preview",
        "NickeManarin.ScreenToGif",
        "Notepad++.Notepad++",
        "Oracle.VirtualBox"
        "PuTTY.PuTTY",
        "Python.Python.3",
        "Spotify.Spotify",
        "Valve.Steam",
        "Zoom.Zoom",
        "elvirbrk.notehighlight2016",
        "ajeetdsouza.zoxide",
        "junegunn.fzf"
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
    "modules" {
        InstallModules
    }
    "all" {
        InstallPwsh
        InstallWinget
        InstallPip
        InstallModules
    }
    default {
        Write-Host "Usage: $(Split-Path $PSCommandPath -Leaf) [pwsh|winget|pip|modules|all]"
    }
}
