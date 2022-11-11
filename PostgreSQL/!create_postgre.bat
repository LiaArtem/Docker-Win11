cd %cd%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './postgresql_build.ps1'"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './postgresql.ps1'"

PowerShell -command "Start-Sleep -s 5"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './postgresql_sql.ps1'"
pause
