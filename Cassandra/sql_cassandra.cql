-- Create a keyspace
CREATE KEYSPACE IF NOT EXISTS testdb WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };

-- Create a table
CREATE TABLE IF NOT EXISTS testdb.curs (
curr_code text,
curs_date date,
forc int,
rate decimal,
PRIMARY KEY (curr_code, curs_date)
);

-- Insert some data
INSERT INTO testdb.curs
(curr_code, curs_date, forc, rate)
VALUES ('USD', '2022-11-12', 1, 37.345);

INSERT INTO testdb.curs
(curr_code, curs_date, forc, rate)
VALUES ('USD', '2022-11-11', 1, 36.5);

-- Change password
ALTER USER cassandra WITH PASSWORD '!Aa112233';