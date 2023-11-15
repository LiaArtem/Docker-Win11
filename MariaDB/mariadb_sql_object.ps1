docker cp ./sql_add_object.sql MariaDBContainer:/opt
docker exec -i MariaDBContainer bash -l -c "mariadb -uroot -p!Aa112233 < /opt/sql_add_object.sql"