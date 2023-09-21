<#

.FILENAME
  dt-demo-box_preparation.ps1

.DESCRIPTION
  deviceTRUST Demo-Box preparation script. Prepares the deviceTRUST Demo-Box installation.

.PARAMETER
  Not available.

.NOTES
  Organization:    deviceTRUST GmbH
  Creation Date:   19/09/2023

#>

$PathTransfer = "$env:SYSTEMDRIVE\Transfer"
$PathDemoBox = "$PathTransfer\dt-demo-box"

# Check Prerequisites
Clear-Host
Write-Host ""
Write-Host " ------------------------------------------------------------------------------------------"
Write-Host " | deviceTRUST Demo-Box preparation script                                                |"
Write-Host " ------------------------------------------------------------------------------------------"
Write-Host ""
Write-Host " Task: Prerequisite Checks (OS Version, OS Membership and Internet Connection)"
Write-Host ""

[bool]$DomainJoinedServerQuery = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
[string]$OSBuildNumber = (Get-WmiObject -class Win32_OperatingSystem).BuildNumber # Needs to be higher than or equal to 14393, which equals Windows Server 2016
[bool]$InternetConnectionAvailable = Test-Connection -ComputerName storage.devicetrust.com -Quiet

if (($DomainJoinedServerQuery -eq $false) -and ($OSBuildNumber -ge "14393") -and ($InternetConnectionAvailable -eq $true)) {

  # Create 'Transfer' folder
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box preparation script                                                |"
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
    Write-Host " | deviceTRUST Demo-Box preparation script                                                |"
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
  Write-Host " | deviceTRUST Demo-Box preparation script                                                |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Task: Unzip 'deviceTRUST Demo-Box' setup file"
  Write-Host ""      

  # Unzip 'deviceTRUST Demo-Box' archive
  if (Test-Path -Path "$PathDemoBox") {Remove-Item -Path "$PathDemoBox" -Recurse -Force}
  Expand-Archive -Path "$PathTransfer\dt-demo-box.zip" -DestinationPath "$PathTransfer" -Force
  Remove-Item -Path "$PathTransfer\dt-demo-box.zip" -Force

  # Preparation successful. The local machine is now ready for the second step.
  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box preparation script                                                |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""
  Write-Host " Info: Preparation successful." -ForegroundColor DarkGreen
  Write-Host ""
  Write-Host " Task: Run configuration or navigate to '$PathDemoBox' and start the script 'dt-demo-box_configuration.ps1' manually."
  Write-Host ""

  $confirmation = Read-Host "Do you want to run the configuration script now (y/n)?"
  if ($confirmation -eq 'y') {
      &"$PathDemoBox/dt-demo-box_configuration.ps1"
  }

  Read-Host " Press any key to close the script"


} else {

  Clear-Host
  Write-Host ""
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host " | deviceTRUST Demo-Box preparation script                                                |"
  Write-Host " ------------------------------------------------------------------------------------------"
  Write-Host ""

  if ($DomainJoinedServerQuery -eq $true) {

    Write-Host " Error: '$env:COMPUTERNAME' is joined to a domain, which isn't supported" -ForegroundColor Red
    Write-Host ""
    Write-Host " Solution: Use a Microsoft Server 2016, 2019 or 2022 as Workgroup Server." -ForegroundColor DarkGreen
    Write-Host ""

  }

  if ($OSBuildNumber -lt "14393") {

    Write-Host " Error: '$OSBuildNumber' isn't supported." -ForegroundColor Red
    Write-Host ""
    Write-Host " Solution: Use a Microsoft Server 2016, 2019 or 2022 as Workgroup Server." -ForegroundColor DarkGreen
    Write-Host ""

  }

  if($InternetConnectionAvailable -ne $true) {

    Write-Host " Error: Your computer is not connected to the internet." -ForegroundColor Red
    Write-Host ""
    Write-Host " Please connect and try again." -ForegroundColor DarkGreen
    Write-Host ""   
  
  }

  Read-Host " Press any key to close the script" 

}