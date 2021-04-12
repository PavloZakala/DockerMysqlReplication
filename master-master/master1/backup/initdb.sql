use mydata;
create user 'replicator'@'%' identified by 'mydb_pwd';
grant replication slave on *.* to 'replicator'@'%';

FLUSH PRIVILEGES;
SHOW MASTER STATUS;
SHOW VARIABLES LIKE 'server_id';