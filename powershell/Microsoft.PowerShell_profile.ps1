$env:SEM = "~\OneDrive\UNI\2022\sem-2"

Import-Module PSReadLine
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'

Set-PSReadlineKeyHandler -Key ctrl+d -Function ViExit

$env:POSH_THEME = "~\AppData\Local\Programs\oh-my-posh\themes\min.omp.json"
oh-my-posh init pwsh | Invoke-Expression

function Edit-PoshTheme {
    omputils theme $args
    . $PROFILE
}

Set-Alias theme Edit-PoshTheme

Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})

function Backup-Onedrive([array]$folders = @("UNI", "Programming", "Tutoring"), [switch]$usb = $false) {
    if ($usb -AND -NOT (Get-PSDrive F -ErrorAction SilentlyContinue)) {
        Write-Error "USB (F:) not found :(" -ErrorAction Stop
    }

    foreach ($folder in $folders) {
        Write-Output "BACKING UP $folder to Desktop"
        xcopy.exe $env:OneDrive\$folder $env:USERPROFILE\Desktop\$folder /d /y /s /e
        if ($usb) {
            Write-Output ""
            Write-Output "BACKING UP $folder to USB"
            xcopy.exe $env:OneDrive\$folder F:\$folder /d /y /s /e
        }
        Write-Output ""
    }
}
