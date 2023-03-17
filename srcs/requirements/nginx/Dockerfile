FROM	debian:buster

# 필요한 package 설치하기
RUN		apt-get update -y && \
		apt-get upgrade -y && \
		apt-get -y install \
		nginx \
		openssl \
		vim

RUN		mkdir /etc/nginx/ssl

# self-signed SSL 인증서 적용 
RUN		openssl req -newkey rsa:4096 -days 365 -nodes -x509 \
		-subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Gon/CN=localhost" \
		-out /etc/ssl/certs/jrim.42.fr.crt \
		-keyout /etc/ssl/private/jrim.42.fr.key
		# localhost 접속시 CA 미인증으로 경고가 뜬다

# SSL 설정 및 url redirection 추가
COPY    conf/nginx.conf /etc/nginx/sites-available/default
		# nginx 관련 설정을 모두 nginx.conf 파일에 해도 되지만
		# nginx 는 설정파일을 나눠서 관리 하는 기능을 제공 하고 있다.
		# sites-available: 가상 서버 환경들에 대한 설정 파일들이 위치하는 부분

EXPOSE	443

# docker run 명령을 실행했을 때 아래의 명령어가 실행된다.
ENTRYPOINT ["nginx", "-g", "daemon off;"]
		# daemon off: nginx 서버를 foreground에서 실행할 수 있게 해준다.
		# 위 명령어가 없으면 -d(background 실행)가 존재해도 컨테이너를 실행할 때 서버가 중지된다.
