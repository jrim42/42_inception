#!/bin/sh

set -e

MYSQL_SETUP_FILE=/var/lib/mysql/.setup

service mysql start

# 처음에만 실행되도록 한다.
if [ ! -e $MYSQL_SETUP_FILE ]; then 

	# mysql -e : mysql에서 명령어를 실행한다.
	mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE";
	mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'";
	mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%'";
	# 변경사항 적용
	mysql -e "FLUSH PRIVILEGES";
	# root 계정의 비밀번호를 변경
	mysql -e "ALTER USER '$MYSQL_ROOT'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'";

	mysql $MYSQL_DATABASE -u$MYSQL_ROOT -p$MYSQL_ROOT_PASSWORD
	mysqladmin -u$MYSQL_ROOT -p$MYSQL_ROOT_PASSWORD shutdown

	touch $MYSQL_SETUP_FILE
fi

exec mysqld_safe
