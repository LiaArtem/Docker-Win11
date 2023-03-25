# Docker-Win11
Docker Windows 11 (Docker, Docker Compose, Kubernetes, Docker Desktop, Kubernetes Dashboard) databases
(Oracle, MS SQL, PostgreSQL, MySQL, MariaDB, IBM DB2, IBM Informix, Firebird, MongoDB, Cassandra).

Установка для Windows 11
----------------------------------------
1) Устанавливаем WSL2
----------------------------------------
Инструкция:
- https://learn.microsoft.com/ru-ru/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package
Шаг 1. Включение подсистемы Windows для Linux
- PowerShell (под администратором) -> dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
Шаг 2. Включение компонента виртуальных машин
- PowerShell (под администратором) -> dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Шаг 3. Перезагрузка ПК
Шаг 4. Установка пакета обновления ядра Linux - wsl_update_x64.msi (https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
Шаг 5. Выбор WSL 2 в качестве версии по умолчанию
- PowerShell (под администратором) -> wsl --set-default-version 2

----------------------------------------
2) Устанавливаем Docker Desktop
----------------------------------------
- https://www.docker.com/products/docker-desktop/

----------------------------------------
3) Добавление Kubernetes
----------------------------------------
- Docker Desktop -> Settings -> Kubernetes -> Enable Kubernetes (ожидаем установки, должен зеленым засветиться значек)
- Kubernetes Dashboard
  - Установка:
  -----------------------------------------------
  -- Инструкция - https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
  - Запускаем .\Kubernetes Dashboard\!create_dashboard_install.bat
  - Запускаем .\Kubernetes Dashboard\!start_dashboard_server.bat (Старт сервера)

  -- Инструкция - https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
  - Запускаем .\Kubernetes Dashboard\!create_dashboard_user.bat (Создание учетных записей служб)
  - Запускаем .\Kubernetes Dashboard\!create_dashboard_token.bat (Для доступа генерация Tokenа)
  - Записать пароль доступа Tokena (пример: eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia......)

  - Запуск - Kubernetes Dashboard:
  -----------------------------------------------
  - Запускаем .\Kubernetes Dashboard\!start_dashboard_server.bat (Старт сервера)

  - *** http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
  - Token - вводим пароль

  - Для пропуска пароля Tokenа:
    - Запускаем .\Kubernetes Dashboard\!kubernetes-dashboard-skip-login-patch.bat (вход без пароля)
    - или Запускаем .\Kubernetes Dashboard\!kubernetes-dashboard-skip-login-edit.bat (вход без пароля через редактирование файла)
    - Пезапускаем .\Kubernetes Dashboard\!start_dashboard_server.bat (Старт сервера)
    - При логине появляется кнопка - Skip (жмем ее для входа)

  -----------------------------------------------
  - Добавляем контейнер
  - Service -> Service -> Create new responce
  - Примеры: .\Kubernetes Container\*.yaml или добавить через Create from form руками.

--------------------------------------------------------------------------
-- Добавление базы данных - MS SQL
--------------------------------------------------------------------------
- Выполняем .\MSSQL\!create_mssql.bat
- Просмотр Microsoft SQL Server Management Studio 19 (host=localhost, user=sa, password=!Aa112233)

Если ошибка:
docker: Error response from daemon: Ports are not available: exposing port TCP 0.0.0.0:1433 -> 0.0.0.0:0:
listen tcp 0.0.0.0:1433: bind: An attempt was made to access a socket in a way forbidden by its access permissions.
- Выполняем .\MSSQL\!create_mssql_restart_winnat.bat

-----------------------------------------------------------------------------
-- Добавление базы данных - PostgreSQL (с расширениями plpython3u и pldbgapi)
-----------------------------------------------------------------------------
- Выполняем .\PostgreSQL\!create_postgre.bat
- Просмотр DBeaver (host=localhost, port=5432, database=postgres, user=postgres, password=!Aa112233)

Дополнительно:
Добавляем русский язык в контейнер Docker Desktop -> PostgreSQLContainer -> Terminal
1) Если же при выводе команды: -> locale -a
2) Если нет русской локали (ru_RU.UTF-8) то ее необходимо сделать: localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
3) Проверяем: -> locale -a

----------------------------------------------------------------------------
-- Добавление базы данных - MySQL
----------------------------------------------------------------------------
- Выполняем .\MySQL\!create_mysql.bat
- Просмотр DBeaver (host=localhost, port=3306, user=root, password=!Aa112233,
                    в соединении вкладка SSL -> Использовать SSL (включить), Проверять сертификаты сервера (выключить))

----------------------------------------------------------------------------
-- Добавление базы данных - MariaDB
----------------------------------------------------------------------------
- Выполняем .\MariaDB\!create_mariadb.bat
- Просмотр DBeaver (host=localhost, port=3307, user=root, password=!Aa112233)

----------------------------------------------------------------------------
-- Добавление базы данных - Oracle
----------------------------------------------------------------------------
- Выполняем .\Oracle\!create_oracle.bat
- Просмотр DBeaver (host=localhost, port=1521, database=XE, user=sys as sysdba, password=!Aa112233)

----------------------------------------------------------------------------
-- Добавление базы данных - MongoDB
----------------------------------------------------------------------------
- Выполняем
  .\MongoDB\!create_mongodb.bat - создание контейнера без создания базы данных testDB
  .\MongoDB\!create_mongodb_init.bat - создание контейнера c созданием базы данных testDB и коллекции Curs
  .\MongoDB\!create_mongodb_compose.bat - создание контейнера внутри сервиса (Docker Compose)
- Просмотр MongoDBCompass(url=mongodb://localhost:27017, Advanced Connection Options -> Authenfication -> Username/Password=root и !Aa112233, Authentication Database=admin, Authentication Mechanism=SCRAM-SHA-1)

----------------------------------------------------------------------------
-- Добавление базы данных - IBM DB2
----------------------------------------------------------------------------
- Выполняем .\IBM DB2\!create_ibmdb2.bat
- Просмотр и установка скриптов DBeaver (host=localhost, port=50000, database=sample, user=DB2INST1, password=!Aa112233)
- Устанавливаем скрипты: .\IBM DB2\sql_add_object.sql

----------------------------------------------------------------------------
-- Добавление базы данных - IBM Informix
----------------------------------------------------------------------------
- Выполняем .\IBM Informix\!create_informix.bat
- Просмотр и установка скриптов DBeaver (host=localhost, port=9088, database=sysadmin, user=informix, password=!Aa112233)
- Устанавливаем скрипты: .\IBM Informix\sql_add_user.sql
- Изменяем настройки DBeaver (host=localhost, port=9088, database=sample, user=informix, password=!Aa112233)
- Устанавливаем скрипты: .\IBM Informix\sql_add_object.sql

----------------------------------------------------------------------------
-- Добавление базы данных - Firebird
----------------------------------------------------------------------------
- Выполняем .\Firebird\!create_firebird.bat
- Просмотр DBeaver (URL=jdbc:firebirdsql://localhost:3050//firebird/data/testdb.fdb, user=SYSDBA, password=!Aa112233)
- Примеры sql скриптов: https://firebirdsql.org/file/documentation/reference_manuals/fbdevgd-en/html/fbdevg30-db-run-script.html

----------------------------------------------------------------------------
-- Добавление базы данных - Cassandra
----------------------------------------------------------------------------
- Выполняем .\Cassandra\!create_cassandra.bat
- Просмотр через RazorSQL
- Устанавливаем скрипты: .\Cassandra\cassandra_data.cql
  (CQL документация - https://cassandra.apache.org/doc/latest/cassandra/cql/index.html)

----------------------------------------------------------------------------
-- Добавление баз данных с помощью Docker Compose для одновременного
-- управления несколькими контейнерами, входящими в состав приложения
----------------------------------------------------------------------------
- Выполняем .\Docker Compose\!create_docker_compose.bat
- Будет создано 3 контейнера с базами данных (MongoDB, IBM DB2, IBM Informix)

----------------------------------------------------------------------------
-- Создание сети в Docker
----------------------------------------------------------------------------
docker network create docker-network
docker network connect docker-network MSSQLContainer
docker network connect docker-network ASP_RESTful_Web_API

-- Проверка настроек сети
docker network inspect docker-network
В результате MSSQLContainer - 172.18.0.2, ASP_RESTful_Web_API - 172.18.0.3

Перечень контейнеров
docker ps