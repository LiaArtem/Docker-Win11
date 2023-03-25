docker cp ./sql_cassandra.cql CassandraContainer:/opt
docker exec -it CassandraContainer cqlsh -u cassandra -p cassandra -f /opt/sql_cassandra.cql

