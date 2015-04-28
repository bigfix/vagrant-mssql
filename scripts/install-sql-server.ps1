# http://stackoverflow.com/a/9949105
$ErrorActionPreference = "Stop"

echo "Disabling password complexity requirement..."

secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false

echo "Installing SQL Server, it will take a while..."

# Set path to the SQL Server ISO image
$imagePath = "C:\vagrant\sqlserver.iso"

$path = "C:\sqlserver.iso"
cp -force $imagePath $path
Mount-DiskImage -ImagePath $path
$driveLetter = (Get-DiskImage $path | Get-Volume).DriveLetter
$setupFile = "{0}:\setup.exe" -f $driveLetter
& $setupFile /Q /Action=install /INDICATEPROGRESS /INSTANCENAME="SQLSERVER" /IAcceptSQLServerLicenseTerms /ROLE=AllFeatures_WithDefaults /FEATURES=SQL,Tools /TCPENABLED=1 /SECURITYMODE="SQL" /SAPWD="bigfix"
Dismount-DiskImage -ImagePath $path
del $path

echo "Disabling firewall"
netsh advfirewall set allprofiles state off
