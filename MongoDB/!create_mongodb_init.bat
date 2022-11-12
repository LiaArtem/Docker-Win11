cd %cd%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mongodb_build.ps1'"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './mongodb_init.ps1'"
pause