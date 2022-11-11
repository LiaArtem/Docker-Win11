docker cp ./sql_add_postgres.sql PostgreSQLContainer:/opt
docker exec -it PostgreSQLContainer psql -U postgres -f /opt/sql_add_postgres.sql

docker cp ./sql_add_testdb.sql PostgreSQLContainer:/opt
docker exec -it PostgreSQLContainer psql -U testdb -f /opt/sql_add_testdb.sql