#!/bin/bash

STACKNAME="wordpressstack"

echo "Bootstrap wordpress..."

sleep 10

docker run -i --rm \
    --volumes-from wordpress \
    --network ${STACKNAME}_app-network \
    wordpress:cli core install --path=/var/www/html --url=127.0.0.1:8080 --title=test --admin_user=test --admin_password=test --admin_email=test@example.com

