#!/bin/bash

if ! [ -d $WP_PATH ];
then
    putBlue "✔ Core download"
    wp core download --path=$WP_PATH --allow-root
fi

cd $WP_PATH;

if [ -f wp-config.php ] && wp config has DB_PASSWORD --allow-root;
then
    echo "wp-config.php is found"
else

    cp wp-config-sample.php wp-config.php

    wp config set --allow-root DB_HOST $DB_HOST --path="."
    wp config set --allow-root DB_NAME $DB_DATABASE --path="." 
    wp config set --allow-root DB_USER $DB_USER --path="."
    wp config set --allow-root DB_PASSWORD "${DB_USER_PASSWORD}" --path="."
    wp config set --allow-root table_prefix $DB_TABLE_PREFIX --path="."
    wp config set --allow-root WP_DEBUG true --path="." --raw
    wp config set --allow-root WP_DEBUG_LOG true --path="." --raw

    wp config shuffle-salts --allow-root

    echo "wp-config.php file generated"

    echo "Installing Wordpress"
    wp core install --allow-root \
        --path="." \
        --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
    wp plugin update --path="." --allow-root --all

    wp user create --path=$WP_PATH --allow-root \
        $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD \
        --role=author
fi

php-fpm7.3 -F
