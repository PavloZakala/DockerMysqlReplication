# Docker MySQL master-master replication 

## Prerequisites
Pre-installed [Docker](https://www.docker.com/).

## Run
Clone the repository, then open the `master-master` folder in the console and run the following commands:
```bash
> docker-compose build
> docker-compose up -d
```

### Mysql1 setting 

If the mysql1 container is loaded correctly, you can open it with this command:
```bash 
> docker -it exec mysql1 bash
```
Open MySQL in the master container:

```bash
> export MYSQL_PWD=111; mysql -u root
```
If you have a message `[Warning] World-writable config file '/etc/mysql/conf.d/mysql.conf.cnf' is ignored` check P.S. section of this readme file.

Run:
```mysql
mysql> source /backup/initdb.sql
```

Notice the following lines in the command output:
 * File: \"mysql-bin.000003\"
 * Position: 777


### Mysql2 setting 
Open up the second console in the `./master2/` and repeat the same steps

```bash 
> docker -it exec mysql2 bash
> export MYSQL_PWD=111; mysql -u root
```
Also if you have a message `[Warning] World-writable config file '/etc/mysql/conf.d/mysql.conf.cnf' is ignored` check P.S. section of this readme file.

```mysql
mysql> source /backup/initdb.sql
```
Also notice the following lines in the command output:
 * File: \"mysql-bin.000003\"
 * Position: 777

The next step is:
```mysql
mysql> STOP SLAVE;
mysql> CHANGE MASTER TO MASTER_HOST = 'mysql1', 
    MASTER_USER = 'replicator',
    MASTER_PASSWORD = 'mydb_pwd', 
    MASTER_LOG_FILE = '{mysql1 File}',
    MASTER_LOG_POS = {mysql1 Position};
mysql> START SLAVE;
```
### Mysql1 setting 
Return to the mysql1 console window and run:
```mysql
mysql> STOP SLAVE;
mysql> CHANGE MASTER TO MASTER_HOST = 'mysql2', 
    MASTER_USER = 'replicator',
    MASTER_PASSWORD = 'mydb_pwd', 
    MASTER_LOG_FILE = '{mysql2 File}',
    MASTER_LOG_POS = {mysql2 Position};
mysql> START SLAVE;
```

## Testing 

Mysql1:
```mysql
mysql> USE mydata;
mysql> CREATE TABLE t1(id int);
```
Mysql2:
```mysql
mysql> USE mydata;
mysql> SHOW TABLES;
mysql> CREATE TABLE t2(id int);
```

Mysql1:
```mysql
mysql> USE mydata;
mysql> SHOW TABLES;
```

## P.S. 
You may see `[Warning] World-writable config file '/etc/mysql/conf.d/mysql.conf.cnf' is ignored` in the console. This message relates to Attributes in the `.cnf` file. Try to shut down docker containers with this command:
```bash 
> docker-compose down
```
and change properties of the `.cnf` file by setting the read-only change mode. After that, repeat all the steps.
