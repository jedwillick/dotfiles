if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  $cmd = "powershell"
    if ($PSVersionTable.PSEdition -eq "Core") {
      $cmd = "pwsh"
    }
  Start-Process $cmd -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
  exit;
}

New-Item -ItemType SymbolicLink -Path $PROFILE -Target (Get-Item powershell/Microsoft.PowerShell_profile.ps1).FullName -Force

foreach ($file in (Get-ChildItem "oh-my-posh\.poshthemes")) {
  New-Item -ItemType SymbolicLink -Path ("$env:POSH_THEMES_PATH\" + $file.Name) -Target $file.FullName -Force
}

foreach ($file in (Get-ChildItem "ssh\.ssh")) {
  New-Item -ItemType SymbolicLink -Path ("~\.ssh\" + $file.Name) -Target $file.FullName -Force
}

New-Item -ItemType SymbolicLink -Path "~\.gitconfig "-Target (Get-Item "git\.gitconfig").FullName -Force
