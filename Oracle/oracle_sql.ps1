docker cp ./sql_add_sys.sql OracleContainer:/opt
docker cp ./sql_add_test_user.sql OracleContainer:/opt
docker cp ./run_sql_add_sys.sh OracleContainer:/opt
docker exec -it OracleContainer bash /opt/run_sql_add_sys.sh