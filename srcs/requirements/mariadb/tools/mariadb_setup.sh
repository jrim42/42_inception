#!/bin/sh

set -e
	# 오류가 발생하면 스크립트를 바로 종료

MYSQL_SETUP_FILE=/var/lib/mysql/.setup

service mysql start

# 처음에만 실행되도록 한다.
if [ ! -e $MYSQL_SETUP_FILE ]; then 

	# mysql -e : mysql에서 명령어를 실행한다.
	mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE";
		# 주어진 이름의 database를 만든다
	mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'";
		# 주어진 이름의 user를 만든다
	mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%'";
		# 특정 계정에게 database를 사용할 수 있는 권한을 준다.

	# 변경사항 적용
	mysql -e "FLUSH PRIVILEGES";
	# root 계정의 비밀번호를 변경
	mysql -e "ALTER USER '$MYSQL_ROOT'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'";

	mysql $MYSQL_DATABASE -u$MYSQL_ROOT -p$MYSQL_ROOT_PASSWORD
	# mysqladmin으로 mysql 서버 종료하기
	mysqladmin -u$MYSQL_ROOT -p$MYSQL_ROOT_PASSWORD shutdown
		# msyqladmin -u root -p shutdown: 현재 사용중인 모든 mysql 사용이 중지된다.

	touch $MYSQL_SETUP_FILE
fi

# mysql 데이터베이스를 시작(실행)하는 명령어 (백그라운드)
exec mysqld_safe
