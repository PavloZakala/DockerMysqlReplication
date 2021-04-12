Docker MySQL master-master replication 

docker-compose build
docker-compose up -d

----------------------- Master 1 -------------------------

docker exec mysql1 bash

export MYSQL_PWD=111; mysql -u root

mysql> source /backup/initdb.sql

----------------------- Master 2 -------------------------

docker exec mysql2 bash
export MYSQL_PWD=111; mysql -u root

mysql> source /backup/initdb.sql
> File: mysql-bin.000003
> Position: 777

stop slave;
CHANGE MASTER TO MASTER_HOST = 'mysql1', 
    MASTER_USER = 'replicator',
    MASTER_PASSWORD = 'mydb_pwd', 
    MASTER_LOG_FILE = '{File}',
    MASTER_LOG_POS = {Position};
start slave;

----------------------- Master 1 -------------------------

stop slave;
CHANGE MASTER TO MASTER_HOST = 'mysql2', 
    MASTER_USER = 'replicator',
    MASTER_PASSWORD = 'mydb_pwd', 
    MASTER_LOG_FILE = '{File}',
    MASTER_LOG_POS = {Position};
start slave;

----------------------- Test -----------------------------

mysql1:
    use mydata;
    create table t1 (id int);

mysql2:
    use mydata;
    show tables;

    create table t2 (id int);

mysql1:
    use mydata;
    show tables;