cd %cd%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './cassandra_build.ps1'"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './cassandra.ps1'"

PowerShell -command "Start-Sleep -s 90"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './cassandra_cqlsh.ps1'"

pause
