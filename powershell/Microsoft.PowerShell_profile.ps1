$env:POSH_THEME = "~\AppData\Local\Programs\oh-my-posh\themes\min.omp.json"
oh-my-posh init pwsh | Invoke-Expression

Set-PSReadlineKeyHandler -Key ctrl+d -Function ViExit
function Edit-PoshTheme {
    omputils theme $args 
    . $PROFILE
}

Set-Alias theme Edit-PoshTheme

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
