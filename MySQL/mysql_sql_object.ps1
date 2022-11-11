docker cp ./sql_add_object.sql MySQLContainer:/opt
docker exec -i MySQLContainer bash -l -c "mysql -uroot -p!Aa112233 < /opt/sql_add_object.sql"