# Docker MySQL master-slave replication

[sourses](https://github.com/vbabak/docker-mysql-master-slave)

## Dependenses
With method is needed pre-installed [Docker](https://www.docker.com/).

## Run
Clone repository, open master-slave folder in console and run:
```bash
> docker-compose build
> docker-compose up -d
```

After with docker created 2 Docker container. Check this using a comand:
```bash 
> docker ps
```


------------------- Master -------------------

docker-compose exec mysql_master bash

export MYSQL_PWD=111; mysql -u root

GRANT REPLICATION SLAVE ON *.* TO "mydb_slave_user"@"%" IDENTIFIED BY "mydb_slave_pwd"; FLUSH PRIVILEGES;

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

P.S. If: mysql: [Warning] World-writable config file '/etc/mysql/conf.d/mysql.conf.cnf' is ignored. then make file real-only https://github.com/cytopia/devilbox/issues/212
