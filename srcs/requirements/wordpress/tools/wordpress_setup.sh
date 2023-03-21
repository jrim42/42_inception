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
# wp config create: Creates a new wp-config.php with database constants, and verifies that the database constants are correct.
	# --dbname=<dbname>: Set the database name.
	# --dbuser=<dbuser>: Set the database user.
	# --dbpass=<dbpass>: Set the database user password.
	# --dbhost=<dbhost>: Set the database host. (default: localhost)
	# --dbcharset=<dbcharset>: Set the database charset. (default: utf8)
# wp core install: Creates the WordPress tables in the database using the URL, title, and default admin user details provided
	# --url=<url>: The address of the new site.
	# --title=<site-title>: The title of the new site.
	# --admin_user=<username>: The name of the admin user.
	# --admin_password=<password>: The password for the admin user. Defaults to randomly generated string.
# wp user create: Creates a new user.
# wp plugin update: Updates one or more plugins.

exec /usr/sbin/php-fpm7.3 -F
