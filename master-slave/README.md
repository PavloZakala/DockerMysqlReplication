Docker MySQL master-slave replication 

docker-compose build
docker-compose up -d

------------------- Master -------------------

docker-compose exec mysql_master bash

export MYSQL_PWD=111; mysql -u root

SHOW MASTER STATUS
> File: mysql-bin.000003
> Position: 600
cat /etc/hosts
> ip: 172.18.0.2

------------------- Slave --------------------

docker-compose exec mysql_slave bash

export MYSQL_PWD=111; mysql -u root

CHANGE MASTER TO MASTER_HOST='172.18.0.2', MASTER_USER='mydb_slave_user', MASTER_PASSWORD='mydb_slave_pwd', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=600; 
START SLAVE;

------------------- Test -----------------------

master:

USE mydb;
CREATE TABLE code(str varchar(10));
insert into code values("Hello");
insert into code values("World");
insert into code values("!!!");

slave:

USE mydb;
SHOW tables;
SELECT * FROM code;