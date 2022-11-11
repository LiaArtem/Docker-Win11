docker cp ./sql_add_testdb.sql FirebirdContainer:/opt
docker exec -it FirebirdContainer /usr/local/firebird/bin/isql -input /opt/sql_add_testdb.sql