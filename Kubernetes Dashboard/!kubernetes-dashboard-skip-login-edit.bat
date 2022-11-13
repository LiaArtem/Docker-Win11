cd %cd%

rem spec:
rem   template:
rem     spec:
rem       containers:
rem       - args:
rem         - --auto-generate-certificates
rem         - --namespace=kubernetes-dashboard
rem #### добавить в окрытом окне и сохранить
rem         - --enable-skip-login                 # add this argument
rem         image: kubernetesui/dashboard:v2.6.1

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './kubernetes-dashboard-edit.ps1'"

pause
