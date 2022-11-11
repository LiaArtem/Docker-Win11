cd %cd%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mssql_build.ps1'"

mkdir c:\temp_mssql_restart_winnat
copy .\mssql_restart_winnat.ps1 C:\temp_mssql_restart_winnat\

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -Verb RunAs powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"C:\temp_mssql_restart_winnat\mssql_restart_winnat.ps1\" -_vLUF %_vLUF%'"

PowerShell -command "Start-Sleep -s 5"
rmdir /s /q c:\temp_mssql_restart_winnat

pause