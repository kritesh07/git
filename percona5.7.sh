#!/bin/bash
case $1 in  
1) yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm -y

			sed -i 's/gpgcheck = 1/gpgcheck = 0/g' /etc/yum.repos.d/percona-original-release.repo

			yum install Percona-XtraDB-Cluster-57 -y

			systemctl start mysqld

echo "

          NOTE:
        After put temparory password you need to set new password for root, for that
        you need to copy & paste following command and exit from mysql



"
echo "




________ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_password';__________




"


			sudo grep 'temporary password' /var/log/mysqld.log

			mysql -u root -p 

			systemctl stop mysqld

				echo "1st node"
				read node1

				echo "2nd node"
				read node2

				echo "node address"
				read node3

				echo "password for sstuser"
				read password

echo  "[mysqld]
wsrep_provider=/usr/lib64/galera3/libgalera_smm.so

wsrep_cluster_name=pxc-cluster
wsrep_cluster_address=gcomm://$node1,$node2

wsrep_node_name=pxc1
wsrep_node_address=$node3

wsrep_sst_method=xtrabackup-v2
wsrep_sst_auth=sstuser:$password

pxc_strict_mode=ENFORCING

binlog_format=ROW
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2" > /etc/my.cnf

				systemctl start mysql@bootstrap

				echo "put your mysql root password"

				mysql -u root -p <<-ENDMARKER

CREATE USER 'sstuser'@'localhost' IDENTIFIED BY '$password';
GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';
FLUSH PRIVILEGES;


ENDMARKER

				systemctl status mysql@bootstrap;;



2) yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm -y

				sed -i 's/gpgcheck = 1/gpgcheck = 0/g' /etc/yum.repos.d/percona-original-release.repo

				yum install Percona-XtraDB-Cluster-57 -y

				systemctl start mysqld

echo "

          NOTE:
        After put temprory password you need to set new password for root, for that
        you need to copy & paste following command and exit from mysql



"
echo "




________ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_password';__________




"


				sudo grep 'temporary password' /var/log/mysqld.log

				mysql -u root -p 

				systemctl stop mysqld

						echo "1st node"
						read node1

						echo "2nd node"
						read node2
			
						echo "node address"
						read node3

						echo "password for sstuser"
						read password

echo  "[mysqld]
wsrep_provider=/usr/lib64/galera3/libgalera_smm.so

wsrep_cluster_name=pxc-cluster
wsrep_cluster_address=gcomm://$node1,$node2

wsrep_node_name=pxc1
wsrep_node_address=$node3

wsrep_sst_method=xtrabackup-v2
wsrep_sst_auth=sstuser:$password

pxc_strict_mode=ENFORCING

binlog_format=ROW
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2" > /etc/my.cnf

						systemctl start mysqld

						systemctl status mysqld;;

esac