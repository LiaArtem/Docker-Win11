docker cp ./sql_add_user.sql MariaDBContainer:/opt
docker exec -i MariaDBContainer bash -l -c "mysql -uroot -p!Aa112233 < /opt/sql_add_user.sql"