cd %cd%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mysql.ps1'"

PowerShell -command "Start-Sleep -s 20"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mysql_sql.ps1'"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mysql_sql_object.ps1'"
pause
