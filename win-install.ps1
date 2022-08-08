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
    "Microsoft.PowerShell",
    "Microsoft.PowerToys",
    "Microsoft.VisualStudioCode",
    "NickeManarin.ScreenToGif",
    "Microsoft.WindowsTerminal.Preview",
    "Valve.Steam",
    "JetBrains.Toolbox",
    "Notepad++.Notepad++",
    "elvirbrk.notehighlight2016"
)

if ($null -eq (Get-Command "winget" -ErrorAction SilentlyContinue)) { 
    Start-Process ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1
    Write-Error "winget must be installed" -ErrorAction Stop

}

Write-Host "Installing winget packages..."
$PACKAGES | Foreach-Object -ThrottleLimit 5 -Parallel {
    $out = winget upgrade --accept-package-agreements --accept-source-agreements $_
    $last = $out.Trim() -split '\r?\n' | Select-Object -Last 1
    if ($last | Select-String -Pattern "No installed package") {
        $out = winget install --accept-package-agreements --accept-source-agreements $_
        $last = $out.Trim() -split '\r?\n' | Select-Object -Last 2
    }
    Write-Host $_.PadRight(30) $last
}
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 

Write-Host ""
Write-Host "Installing pip packages..."
python -m pip install --upgrade pip
pip install --upgrade -r pip-packages.txt