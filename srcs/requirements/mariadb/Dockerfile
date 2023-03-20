FROM	debian:buster

RUN		apt-get update -y && \
		apt-get upgrade -y && \
		apt-get -y install \
		mariadb-server \
		mariadb-client \
		vim

COPY	./tools/mariadb_setup.sh /tmp/mariadb_setup.sh
COPY	./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

ENTRYPOINT ["sh", "/tmp/mariadb_setup.sh"]

# 이 docker image는 3306번 포트를 외부에 공개할 예정이라는 의미
EXPOSE 3306