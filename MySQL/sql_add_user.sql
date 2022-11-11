CREATE USER 'test_user'@'localhost' IDENTIFIED BY '!Aa112233';
GRANT ALL PRIVILEGES ON * . * TO 'test_user'@'localhost';

CREATE USER 'test_user'@'172.17.0.1' IDENTIFIED BY '!Aa112233';
GRANT ALL PRIVILEGES ON * . * TO 'test_user'@'172.17.0.1';

CREATE SCHEMA `test_schemas`;