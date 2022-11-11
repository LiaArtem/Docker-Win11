cd %cd%
rem current location of the database -> The value(s) of DatabaseAccess in firebird.conf
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './firebird.ps1'"

PowerShell -command "Start-Sleep -s 5"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './firebird_sql.ps1'"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './firebird_sql_object.ps1'"
pause
