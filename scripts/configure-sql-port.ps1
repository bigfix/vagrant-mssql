# http://stackoverflow.com/a/9949105
$ErrorActionPreference = "Stop"

echo "Configuring TCP port"

# http://technet.microsoft.com/en-us/library/dd206997(v=sql.105).aspx
# Load assemblies
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")

# http://www.dbi-services.com/index.php/blog/entry/sql-server-2012-configuring-your-tcp-port-via-powershell
# Set the port
$smo = 'Microsoft.SqlServer.Management.Smo.'
$wmi = New-Object ($smo + 'Wmi.ManagedComputer')
$uri = "ManagedComputer[@Name='VAGRANT-2012-R2']/ ServerInstance[@Name='SQLSERVER']/ServerProtocol[@Name='Tcp']"
$Tcp = $wmi.GetSmoObject($uri)
$wmi.GetSmoObject($uri + "/IPAddress[@Name='IPAll']").IPAddressProperties[1].Value="1433"
$Tcp.alter()

echo "DONE!"

echo "Restarting service..."
# Restart service so that configurations are applied
restart-service -f "SQL Server (SQLSERVER)"
echo "DONE!"
