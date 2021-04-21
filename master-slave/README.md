# Docker MySQL master-slave replication

[sources](https://github.com/vbabak/docker-mysql-master-slave)

## Prerequisites
Pre-installed [Docker](https://www.docker.com/).

## Run
Clone the repository, then open the `master-slave` folder in the console and run the following commands:
```bash
> docker-compose build
> docker-compose up -d
```

Docker has created two docker containers. Check them using this comand:
```bash 
> docker ps
```
Loading docker containers can take a while. 

### Master setting 

If the master container is loaded correctly, you can open it with this command:
```bash 
> docker-compose exec mysql_master bash
```

Before runnnig MySQL, you need to find out your IP address:
```bash
> cat /etc/hosts
  ***
ff02::2 ip6-allrouters
172.22.0.2      dcef07e8c2ba
```

After that, open MySQL in the master container:
```bash
> export MYSQL_PWD=111; mysql -u root
```
If you have a message `[Warning] World-writable config file '/etc/mysql/conf.d/mysql.conf.cnf' is ignored` check section P.S. in this readme file.

Run:
```mysql
mysql> GRANT REPLICATION SLAVE ON \*.\* TO "mydb_slave_user"@"%" IDENTIFIED BY "mydb_slave_pwd"; FLUSH PRIVILEGES;
mysql> SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000003 |      752 | mydb         |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
```
Notice the following lines in the command output:
  * File name:  \"mysql-bin.000003\"
  * Position: 752

Also, remember the IP address \"172.22.0.2\".

### Slave setting 

Open the second console in the `./master-slave/` folder and run this command:
```bash
> docker-compose exec mysql_slave bash
```
Open MySQL in the slave container:
```bash
export MYSQL_PWD=111; mysql -u root
```
If you have a message `[Warning] World-writable config file '/etc/mysql/conf.d/mysql.conf.cnf' is ignored` check section P.S. in this readme file.

Set up replication:
```mysql
mysql> CHANGE MASTER TO MASTER_HOST='{master IP address}', MASTER_USER='mydb_slave_user', MASTER_PASSWORD='mydb_slave_pwd', MASTER_LOG_FILE='{master File name}', MASTER_LOG_POS={master Position}; 
mysql> START SLAVE;
```
## Testing 

Master:
```mysql 
mysql> USE mydb;
mysql> CREATE TABLE code(str varchar(10));
mysql> INSERT INTO code VALUES("Hello");
mysql> INSERT INTO code VALUES("World");
mysql> INSERT INTO code VALUES("!!!");
```
Slave:
```mysql 
mysql> USE mydb;
mysql> SHOW tables;
mysql> SELECT * FROM code;
```
## P.S. 
You may see `[Warning] World-writable config file '/etc/mysql/conf.d/mysql.conf.cnf' is ignored` in the console. This message relates to Attributes in the `.cnf` file. Try to shut down docker containers with this command:
```bash 
> docker-compose down
```
and change properties of the `.cnf` file by setting the read-only change mode. After that, repeat all the steps.
