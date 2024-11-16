net stop winnat
docker run --name MSSQLContainer --restart=always -p 1433:1433 -d mssqlappdev:manual-latest
net start winnat

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
