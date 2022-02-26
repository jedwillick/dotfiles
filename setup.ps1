$bak = "C:\temp\dotfiles.bak\" + (Get-Date -Format "MM-dd-yyyy_HH.mm.ss")

New-Item -ItemType Directory -Path $bak

Copy-Item -Path $PROFILE -Destination ("$bak\" + $PROFILE.Name) -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $PROFILE -Target (Get-Item powershell/Microsoft.PowerShell_profile.ps1).FullName -Force

New-Item -ItemType Directory -Path "$bak\.poshthemes"
foreach ($file in (Get-ChildItem "dotfiles\.poshthemes")) {
    Copy-Item -Path ("~\AppData\Local\Programs\oh-my-posh\themes\" + $file.Name) -Destination ("$bak\.poshthemes\" + $file.Name) -ErrorAction SilentlyContinue
    New-Item -ItemType SymbolicLink -Path ("~\AppData\Local\Programs\oh-my-posh\themes\" + $file.Name) -Target $file.FullName -Force
}

New-Item -ItemType Directory -Path "$bak\.ssh"
foreach ($file in (Get-ChildItem "dotfiles\.ssh")) {
    Copy-Item -Path ("~\.ssh\" + $file.Name) -Destination ("$bak\.ssh\" + $file.Name) -ErrorAction SilentlyContinue
    New-Item -ItemType SymbolicLink -Path ("~\.ssh\" + $file.Name) -Target $file.FullName -Force
}

Copy-Item -Path "~\.gitconfig" -Destination ("$bak\.gitconfig") -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path "~\.gitconfig "-Target (Get-Item "dotfiles\.gitconfig").FullName -Force