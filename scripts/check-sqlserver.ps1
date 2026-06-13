# Verifica conexion TCP a SQL Server (puerto 1433)

Write-Host "=== Diagnostico SQL Server (SQLEXPRESS02) ===" -ForegroundColor Cyan

$regBase = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL17.SQLEXPRESS02\MSSQLServer\SuperSocketNetLib\Tcp"
$tcpEnabled = (Get-ItemProperty $regBase -ErrorAction SilentlyContinue).Enabled
$tcpPort = (Get-ItemProperty "$regBase\IPAll" -ErrorAction SilentlyContinue).TcpPort
$service = Get-Service "MSSQL`$SQLEXPRESS02" -ErrorAction SilentlyContinue

Write-Host "TCP habilitado: $(if ($tcpEnabled -eq 1) { 'SI' } else { 'NO' })"
Write-Host "Puerto configurado: $(if ($tcpPort) { $tcpPort } else { '(ninguno)' })"
Write-Host "Servicio SQLEXPRESS02: $($service.Status)"

$port = if ($tcpPort) { $tcpPort } else { "1433" }
$listening = netstat -an | Select-String ":$port "
Write-Host "Escuchando en ${port}: $(if ($listening) { 'SI - listo para el Back' } else { 'NO - ejecuta scripts/fix-sqlserver-tcp.ps1 COMO ADMIN' })" -ForegroundColor $(if ($listening) { 'Green' } else { 'Yellow' })
