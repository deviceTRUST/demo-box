<#

.FILENAME
  dt-demo-box-ctx.ps1

.DESCRIPTION
  deviceTRUST Demo-Box installation script for Citrix environment. Installs and configures the deviceTRUST Demo-Box installation in a Citrix environment.

.PARAMETER
  Not available.

.NOTES
  Organization:    deviceTRUST GmbH
  Creation Date:   14/01/2025

#>

$PathTransfer = "$env:SYSTEMDRIVE\Transfer"
$PathDemoBox = "$PathTransfer\dt-demo-box"

# Check Prerequisites
Clear-Host
Write-Host ""
Write-Host " ------------------------------------------------------------------------------------------"
Write-Host " | deviceTRUST Demo-Box installation script                                               |"
Write-Host " ------------------------------------------------------------------------------------------"
Write-Host ""
Write-Host " Task: Prerequisite Checks (OS Version, OS Membership and Internet Connection)"
Write-Host ""

[string]$OSBuildNumber = (Get-WmiObject -class Win32_OperatingSystem).BuildNumber # Needs to be higher than or equal to 14393, which equals Windows Server 2016

if ($OSBuildNumber -ge "14393") {

  # Create 'Transfer' folder
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Create '$PathTransfer' folder"
  Write-Host ""

  if (-not (Test-Path -Path "$PathTransfer")) {

    New-Item -ItemType directory -Name "Transfer" -Path "$env:SYSTEMDRIVE\"
    $Acl = Get-Acl -Path "$PathTransfer"
    $Permission = 'BUILTIN\Users', 'FullControl', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
    $Rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $Permission
    $Acl.SetAccessRule($Rule)
    $Acl | Set-Acl -Path "$PathTransfer"

  }


  if(-not (Test-Path "$PathTransfer\dt-demo-box.zip")){

    # Download 'deviceTRUST Demo-Box' setup file
    Clear-Host
    Write-Host ""
    Write-Host " ------------------------------------------------------------------------------------------"
    Write-Host " | deviceTRUST Demo-Box installation script                                               |"
    Write-Host " ------------------------------------------------------------------------------------------"
    Write-Host ""
    Write-Host " Task: Download 'deviceTRUST Demo-Box' setup file"
    Write-Host ""

    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri "https://github.com/deviceTRUST/demo-box/raw/main/dt-demo-box.zip" -OutFile "$PathTransfer\dt-demo-box.zip"

  }


  # Unzip 'deviceTRUST Demo-Box' setup file
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Unzip 'deviceTRUST Demo-Box' setup file"
  Write-Host ""      

  # Unzip 'deviceTRUST Demo-Box' archive
  if (Test-Path -Path "$PathDemoBox") {Remove-Item -Path "$PathDemoBox" -Recurse -Force}
  Expand-Archive -Path "$PathTransfer\dt-demo-box.zip" -DestinationPath "$PathTransfer" -Force
  Remove-Item -Path "$PathTransfer\dt-demo-box.zip" -Force

  # Rename 'System Drive'
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Set 'System Drive' description"
  Write-Host ""

  [string]$SystemDriveLetter = ($env:SYSTEMDRIVE).TrimEnd(":")
  Set-Volume -DriveLetter $SystemDriveLetter -NewFileSystemLabel "System Drive"

  # Set 'Password never expires for local administrator'
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Set 'Password never expires for local administrator'"
  Write-Host ""

  $ArgumentList = "/c" + " wmic useraccount WHERE Name='Administrator' set PasswordExpires=false"
  Start-Process -FilePath "C:\Windows\System32\cmd.exe" -ArgumentList $ArgumentList

  # Add 'deviceTRUST Demo User'
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Add 'deviceTRUST Demo User' with password '" -NoNewline
  Write-Host "dT$" -NoNewline -ForegroundColor Yellow
  Write-Host "'"
  Write-Host ""

  $PasswordEncrypted = ConvertTo-SecureString -String "dT$" -AsPlainText -Force
  New-LocalUser -Name "User" -FullName "deviceTRUST Demo" -Password $PasswordEncrypted -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword
  Add-LocalGroupMember -SID "S-1-5-32-555" -Member "User"

  # Add 'SW-Install User'
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Add 'SW-Install User' with password '" -NoNewline
  Write-Host "dT$" -NoNewline -ForegroundColor Yellow
  Write-Host "'"
  Write-Host ""

  $PasswordEncrypted = ConvertTo-SecureString -String "dT$" -AsPlainText -Force
  New-LocalUser -Name "SW-Install" -FullName "SW-Install" -Password $PasswordEncrypted -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword

  # Add 'Admin User'
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Add 'Admin User' with password '" -NoNewline
  Write-Host "dT$" -NoNewline -ForegroundColor Yellow
  Write-Host "'"
  Write-Host ""

  $PasswordEncrypted = ConvertTo-SecureString -String "dT$" -AsPlainText -Force
  New-LocalUser -Name "Admin" -FullName "Admin" -Password $PasswordEncrypted -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword

  # Disable 'IE Enhanced Security Configuration' for all users
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Disable 'IE Enhanced Security Configuration' for administrators and users"
  Write-Host ""

  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components" -Name "IsInstalled" -Value 0 -Force
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 -Force
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 -Force

  # Configure 'Administrator' environment
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Configure 'Administrator' environment"
  Write-Host ""

  # Clear the wallpaper setting for the current user's desktop
  Clear-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallPaper" -Force

  # Set the background color for the desktop to RGB values 74, 84, 89
  Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name "Background" -Value "74 84 89" -Force

  # Configure advanced settings for Windows Explorer
  Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -Force
  Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Force
  New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AlwaysShowMenus" -PropertyType DWord -Value 1 -Force
  New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NavPaneExpandToCurrentFolder" -PropertyType DWord -Value 1 -Force

  # Create registry entries to hide desktop icons
  New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "HideDesktopIcons" -Force
  New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons" -Name "NewStartPanel" -Force
  New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -PropertyType DWord -Value 0 -Force
  New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWord -Value 0 -Force
  New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -PropertyType DWord -Value 0 -Force

  # Configure registry entries for Regedit favorites
  New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets" -Name "Regedit" -Force
  New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "Favorites" -Force
  New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" -Name "Contexts" -PropertyType String -Value "Computer\HKEY_CURRENT_USER\Software\deviceTRUST\Contexts" -Force
  New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" -Name "Properties" -PropertyType String -Value "Computer\HKEY_CURRENT_USER\Software\deviceTRUST\Properties" -Force

  # Setup printer 'Corporate', 'Floor 1' and 'Floor 2'
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Setup printer 'Corporate', 'Floor 1' and 'Floor 2'"
  Write-Host ""

  Add-PrinterDriver -Name "Generic / Text Only"
  Add-Printer -Name "Corporate" -DriverName "Generic / Text Only" -PortName LPT1:
  Add-Printer -Name "Floor 1" -DriverName "Generic / Text Only" -PortName LPT2:
  Add-Printer -Name "Floor 2" -DriverName "Generic / Text Only" -PortName LPT3:

  # Install Chocolatey for apllication installation
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box Preperation Script                                                |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Install Chocolatey"
  Write-Host ""

  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

  # Install Chocolatey Auto-Update-Task
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box Preperation Script                                                |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Install Chocolatey Auto-Update-Task"
  Write-Host ""

  choco install upgrade-all-at --y --quiet

  # Install required software via Chocolatey
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box Preperation Script                                                |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Install required software via Chocolatey."
  Write-Host ""

  $ProgressPreference = 'SilentlyContinue'
  choco install FSLogix NotepadPlusPlus zoomit dt-agent dt-console --y --quiet

  # Configure deviceTRUST policy
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Configure deviceTRUST policy"
  Write-Host ""

  Copy-Item -Path "$PathDemoBox\Content\dtpol\dt-demo-box.dtpol" -Destination "$env:PROGRAMDATA\deviceTRUST\Policy" -Force

  # Copy files and create folder(s)
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Copy files and create folder(s)"
  Write-Host ""

  # Copy Registry Editor shortcut to the Public Desktop
  Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools\Registry Editor.lnk" -Destination "$env:SYSTEMDRIVE\Users\Public\Desktop" -Force

  # Copy FSLogix configuration files to the FSLogix Rules directory
  Copy-Item -Path "$PathDemoBox\Content\Configuration\FSLogix\*" -Destination "C:\Program Files\FSLogix\Apps\Rules" -Force

  # Create a directory "Demo Tool" on the user's desktop and copy a demo tool executable
  New-Item -ItemType directory -Name "Demo Tool" -Path "$env:USERPROFILE\Desktop\deviceTRUST Demo-Box" -Force
  Copy-Item -Path "$PathDemoBox\Content\Software\deviceTRUST\dtdemotool.exe" -Destination "$env:USERPROFILE\Desktop\deviceTRUST Demo-Box\Demo Tool" -Force

  # Create a directory "Presentation" on the user's desktop and copy presentation files
  New-Item -ItemType directory -Name "Presentation" -Path "$env:USERPROFILE\Desktop\deviceTRUST Demo-Box" -Force
  Copy-Item -Path "$PathDemoBox\Content\Presentation\*" -Destination "$env:USERPROFILE\Desktop\deviceTRUST Demo-Box\Presentation" -Force

  # Create a directory "Links" in the user's Favorites and copy a URL shortcut
  New-Item -ItemType directory -Name "Links" -Path "$env:USERPROFILE\Favorites\" -Force
  Copy-Item -Path "$PathDemoBox\Content\Favorites\Business Web App.url" -Destination "$env:USERPROFILE\Favorites\Links\Business Web App.url" -Force

  # Create a directory "Scripts" on the system drive and copy authorized and unauthorized scripts
  New-Item -ItemType directory -Name "Scripts" -Path "$env:SYSTEMDRIVE\" -Force
  Copy-Item -Path "$PathDemoBox\Content\Scripts\Authorized\*.*" -Destination "$env:SYSTEMDRIVE\Scripts" -Force
  Copy-Item -Path "$PathDemoBox\Content\Scripts\Unauthorized\*.*" -Destination "$env:SYSTEMDRIVE\Users\Default\Downloads" -Force

  # Get the SID of the "SW-Install" local user and use SetACL to set ownership of the Scripts directory
  [string]$SwInstallSid = ((Get-LocalUser "SW-Install").Sid).Value
  Start-Process -FilePath "$PathDemoBox\Content\Software\SetACL-3.1.2\SetACL.exe" -ArgumentList "-on ""$env:SYSTEMDRIVE\Scripts"" -ot file -actn setowner -ownr ""n:$SwInstallSid"" -rec cont_obj" -Wait

  # Clean up
  if (Test-Path -Path "$env:USERPROFILE\Desktop\dt-demo-box_preparation.ps1") {Remove-Item -Path "$env:USERPROFILE\Desktop\dt-demo-box_preparation.ps1" -Force}

  $confirmation = Read-Host "Your computer needs to be restarted to finish the configuration. Restart now? (y/n)?"
  if ($confirmation -eq 'y') {

    # Computer will automatically restart in 10 seconds
    Clear-Host
    Write-Host ""
    Write-Host " ------------------------------------------------------------------------------------------"
    Write-Host " | deviceTRUST Demo-Box installation script                                               |"
    Write-Host " ------------------------------------------------------------------------------------------"
    Write-Host ""
    Write-Host " Task: Computer will automatically restart in 10 seconds"
    Write-Host ""

    Start-Sleep -Seconds 10
    Restart-Computer -Force

  }

} else {

  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box installation script                                               |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""

  if ($OSBuildNumber -lt "14393") {

    Write-Host " Error: '$OSBuildNumber' isn't supported." -ForegroundColor Red
    Write-Host ""
    Write-Host " Solution: Use a Microsoft Server 2016, 2019 or 2022 as Workgroup Server." -ForegroundColor DarkGreen
    Write-Host ""

  }

  Read-Host " Press any key to close the script" 

}