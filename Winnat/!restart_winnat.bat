cd %cd%

mkdir c:\temp_restart_winnat
copy .\restart_winnat.ps1 C:\temp_restart_winnat\

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -Verb RunAs powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"C:\temp_restart_winnat\restart_winnat.ps1\" -_vLUF %_vLUF%'"

PowerShell -command "Start-Sleep -s 5"
rmdir /s /q c:\temp_restart_winnat

pause