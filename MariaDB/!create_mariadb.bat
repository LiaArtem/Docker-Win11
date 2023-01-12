cd %cd%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mariadb.ps1'"

PowerShell -command "Start-Sleep -s 30"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mariadb_sql.ps1'"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mariadb_sql_object.ps1'"
pause
