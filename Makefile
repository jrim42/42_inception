NAME = inception

VOLUME_PATH	:= /home/jrim/data
HOST_LINK	:= "127.0.0.1	jrim.42.fr" > /etc/hosts

all		:	$(NAME)

$(NAME)	:
	@sudo chmod 666 /var/run/docker.sock
	@sudo mkdir -p $(VOLUME_PATH)/mariadb/
	@sudo mkdir -p $(VOLUME_PATH)/wordpress/
	@sudo echo $(HOST_LINK)
	@sudo docker-compose -f ./srcs/docker-compose.yml up --build -d

up		:
	@sudo docker-compose -f ./srcs/docker-compose.yml up -d

down	:
	@sudo docker-compose -f ./srcs/docker-compose.yml down

clean	:
	@sudo docker-compose -f ./srcs/docker-compose.yml down --rmi all --volumes

fclean	: clean
	@sudo rm -rf $(VOLUME_PATH)

re	: fclean all

.PHONY	: all down clean fclean re
