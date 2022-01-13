CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';
CREATE USER 'hive'@'localhost' IDENTIFIED BY 'hive';
CREATE USER 'hive'@'127.0.0.1' IDENTIFIED BY 'hive';
CREATE USER 'hive'@'slavenode' IDENTIFIED BY 'hive';

GRANT all privileges on *.* to 'hive'@'%';
GRANT all privileges on *.* to 'hive'@'localhost';
GRANT all privileges on *.* to 'hive'@'127.0.0.1';
GRANT all privileges on *.* to 'hive'@'slavenode';

flush privileges;