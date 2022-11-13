cd %cd%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './dashboard-adminuser.ps1'"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './ClusterRoleBinding.ps1'"

pause
