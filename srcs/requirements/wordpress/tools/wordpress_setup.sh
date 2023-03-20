#!/bin/sh

set -e

# 파일의 소유자를 변경하는 명령
chown -R www-data:www-data /var/www/
	# -R: Change the user ID and/or the group ID 
	# for the file hierarchies rooted in the files instead of just the files themselves.

if [ ! -f "/var/www/html/wordpress/index.php" ]; then
	sudo -u www-data sh -c " \
	wp core download --locale=$WORDPRESS_LANG && \
	wp config create --dbname=$WORDPRESS_DB_HOST --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --dbcharset="utf8"
	wp core install --url=$DOMAIN_NAME --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_DB_ADMIN --admin_password=$WORDPRESS_DB_ADMIN_PASSWORD --admin_email=$WORDPRESS_DB_ADMIN_EMAIL --skip-email && \
	wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --role=author --user_pass=$WORDPRESS_PASSWORD && \
	wp plugin update --all
	"
fi

# wp core download: Downloads and extracts WordPress core files to the specified path
	# --locale=<locale>: Select which language you want to download
# wp core install: Creates the WordPress tables in the database using the URL, title, and default admin user details provided
	# --url=<url>: The address of the new site.

exec /usr/sbin/php-fpm7.3 -F
