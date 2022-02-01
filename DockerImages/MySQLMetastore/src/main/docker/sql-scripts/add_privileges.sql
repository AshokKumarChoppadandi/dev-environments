CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';
CREATE USER 'hive'@'localhost' IDENTIFIED BY 'hive';
CREATE USER 'hive'@'127.0.0.1' IDENTIFIED BY 'hive';
CREATE USER 'hive'@'slavenode' IDENTIFIED BY 'hive';

GRANT all privileges on *.* to 'hive'@'%';
GRANT all privileges on *.* to 'hive'@'localhost';
GRANT all privileges on *.* to 'hive'@'127.0.0.1';
GRANT all privileges on *.* to 'hive'@'slavenode';

CREATE USER 'grafana'@'%' IDENTIFIED BY 'grafana';
CREATE USER 'grafana'@'localhost' IDENTIFIED BY 'grafana';
CREATE USER 'grafana'@'127.0.0.1' IDENTIFIED BY 'grafana';

GRANT all privileges on *.* to 'grafana'@'%';
GRANT all privileges on *.* to 'grafana'@'localhost';
GRANT all privileges on *.* to 'grafana'@'127.0.0.1';

flush privileges;