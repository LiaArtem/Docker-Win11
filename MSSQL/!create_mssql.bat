cd %cd%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mssql_build.ps1'"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mssql.ps1'"
pause
