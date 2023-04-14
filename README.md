# Docker-Win11
Docker Windows 11 (Docker, Docker Compose, Kubernetes, Docker Desktop, Kubernetes Dashboard) databases
(Oracle, MS SQL, PostgreSQL, MySQL, MariaDB, IBM DB2, IBM Informix, Firebird, MongoDB, Cassandra).

Установка для Windows 11

---------------------------------------------------------------------------------
1) Встановлюємо WSL2
  Інструкція:
    https://learn.microsoft.com/ru-ua/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package
  - Крок 1. Увімкнення підсистеми Windows для Linux
    - PowerShell (під адміністратором) -> dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
  - Крок 2. Увімкнення компонента віртуальних машин
    - PowerShell (під адміністратором) -> dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
  - Крок 3. Перезавантаження ПК
  - Крок 4. Встановлення пакета оновлень ядра Linux - wsl_update_x64.msi (https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
  - Крок 5. Вибір WSL 2 як стандартної версії.
    - PowerShell (під адміністратором) -> wsl --set-default-version 2

---------------------------------------------------------------------------------
2) Встановлюємо Docker Desktop:
   - https://www.docker.com/products/docker-desktop/

---------------------------------------------------------------------------------
3) Додавання Kubernetes:
   - Docker Desktop -> Settings -> Kubernetes -> Enable Kubernetes (очікуємо установки, повинен зеленим засвітитися знак)
   - Kubernetes Dashboard
     - Установка:
       - Інструкція - https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
       - Запускаємо .\Kubernetes Dashboard\!create_dashboard_install.bat
       - Запускаємо .\Kubernetes Dashboard\!start_dashboard_server.bat (Старт сервера)

       - Інструкція - https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
       - Запускаємо .\Kubernetes Dashboard\!create_dashboard_user.bat (Створення облікових записів служб)
       - Запускаємо .\Kubernetes Dashboard\!create_dashboard_token.bat (Для доступу генерації Tokenа)
       - Записати пароль доступу Tokena (приклад: eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia......)

---------------------------------------------------------------------------------
4) Запуск - Kubernetes Dashboard:
   - Запускаємо .\Kubernetes Dashboard\!start_dashboard_server.bat (Старт сервера)

   - *** http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
   - Token – вводимо пароль

   - Для пропуску пароля Token:
     - Запускаємо .\Kubernetes Dashboard\!kubernetes-dashboard-skip-login-patch.bat (вхід без пароля)
     - або Запускаємо .\Kubernetes Dashboard\!kubernetes-dashboard-skip-login-edit.bat (вхід без пароля через редагування файлу)
     - Пезапускаємо .\Kubernetes Dashboard\!start_dashboard_server.bat (Старт сервера)
     - При логіні з'являється кнопка - Skip (тиснемо її для входу)

     - Додаємо контейнер
     - Service -> Service -> Create new responce
     - Приклади: .\Kubernetes Container\*.yaml або додати через Create from form руками.

---------------------------------------------------------------------------------
Додавання бази даних - MS SQL

  - Виконуємо .\MSSQL\!create_mssql.bat
  - Перегляд Microsoft SQL Server Management Studio 19 (host=localhost, user=sa, password=!Aa112233)

  Якщо помилка:
  docker: Error response from daemon: ports no available: exposing port TCP 0.0.0.0:1433 -> 0.0.0.0:0:
  listen tcp 0.0.0.0:1433: bind: An attempt was made to access a socket in a way forbidden by its access permissions.
  - Виконуємо .\MSSQL\!create_mssql_restart_winnat.bat

---------------------------------------------------------------------------------
Додавання бази даних - PostgreSQL (з розширеннями plpython3u та pldbgapi)

  - Виконуємо .\PostgreSQL\!create_postgre.bat
  - Перегляд DBeaver (host=localhost, port=5432, database=postgres, user=postgres, password=!Aa112233)

  Додатково:
  Додаємо українську мову в контейнер Docker Desktop -> PostgreSQLContainer -> Terminal
  1) Якщо ж під час виведення команди: -> locale -a
  2) Якщо немає української локалі (uk_UA.UTF-8) то її необхідно зробити: localedef -i uk_UA -f UTF-8 uk_UA.UTF-8
  3) Перевіряємо: -> locale -a

---------------------------------------------------------------------------------
Додавання бази даних - MySQL

  - Виконуємо .\MySQL\!create_mysql.bat
  - Перегляд DBeaver (host=localhost, port=3306, user=root, password=!Aa112233,
    у з'єднанні вкладка SSL -> Використовувати SSL (увімкнути), Перевіряти сертифікати сервера (вимкнути))

---------------------------------------------------------------------------------
Додавання бази даних - MariaDB

  - Виконуємо .\MariaDB\!create_mariadb.bat
  - Перегляд DBeaver (host=localhost, port=3307, user=root, password=!Aa112233)

---------------------------------------------------------------------------------
Додавання бази даних - Oracle XE

  - Виконуємо .\Oracle\!create_oracle.bat
  - Перегляд DBeaver (host=localhost, port=1521, database=XE, user=sys як sysdba, password=!Aa112233)

---------------------------------------------------------------------------------
Додавання бази даних - MongoDB

  - Виконуємо:
    .\MongoDB\!create_mongodb.bat - створення контейнера без створення бази даних testDB
    .\MongoDB\!create_mongodb_init.bat - створення контейнера зі створенням бази даних testDB та колекції Curs
    .\MongoDB\!create_mongodb_compose.bat - створення контейнера всередині сервісу (Docker Compose)
  - Перегляд MongoDBCompass(url=mongodb://localhost:27017, Advanced Connection Options -> Authenfication -> Username/Password=root і !Aa112233, Authentication Database=admin, Authentication Mechanism=SCRAM-SHA-1)

---------------------------------------------------------------------------------
Додавання бази даних - IBM DB2

  - Виконуємо .\IBM DB2\!create_ibmdb2.bat
  - Перегляд та встановлення скриптів DBeaver (host=localhost, port=50000, database=sample, user=DB2INST1, password=!Aa112233)
  - Встановлюємо скрипти: .\IBM DB2\sql_add_object.sql

---------------------------------------------------------------------------------
Додавання бази даних - IBM Informix

  - Виконуємо .\IBM Informix\!create_informix.bat
  - Перегляд та встановлення скриптів DBeaver (host=localhost, port=9088, database=sysadmin, user=informix, password=!Aa112233)
  - Встановлюємо скрипти: .\IBM Informix\sql_add_user.sql
  - Змінюємо налаштування DBeaver (host=localhost, port=9088, database=sample, user=informix, password=!Aa112233)
  - Встановлюємо скрипти: .\IBM Informix\sql_add_object.sql

---------------------------------------------------------------------------------
Додавання бази даних - Firebird

  - Виконуємо .\Firebird\!create_firebird.bat
  - Перегляд DBeaver (URL=jdbc:firebirdsql://localhost:3050//firebird/data/testdb.fdb, user=SYSDBA, password=!Aa112233)
  - Приклади sql скриптів: https://firebirdsql.org/file/documentation/reference_manuals/fbdevgd-en/html/fbdevg30-db-run-script.html

-------------------------------------------------- --------------------------
Додавання бази даних - Cassandra

  - Виконуємо .\Cassandra\!create_cassandra.bat
  - Перегляд через RazorSQL
  - Встановлюємо скрипти: .\Cassandra\cassandra_data.cql
    (CQL документація - https://cassandra.apache.org/doc/latest/cassandra/cql/index.html)

---------------------------------------------------------------------------------
Додавання баз даних за допомогою Docker Compose для одночасного керування кількома контейнерами, що входять до складу програми

  - Виконуємо .\Docker Compose\!create_docker_compose.bat
  - Буде створено 3 контейнери з базами даних (MongoDB, IBM DB2, IBM Informix)

---------------------------------------------------------------------------------
Створення мережі в Docker

  docker network create docker-network
  docker network connect docker-network MSSQLContainer
  docker network connect docker-network ASP_RESTful_Web_API

  - Перевірка налаштувань мережі
    docker network inspect docker-network
  В результаті MSSQLContainer - 172.18.0.2, ASP_RESTful_Web_API - 172.18.0.3

Перелік контейнерів
docker ps