# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
echo "Installing Docker and docker-compose..."
sudo apt-get update
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common vim -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
sudo apt-get update
sudo apt-get install -y docker-ce
# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
sudo service docker restart
# Make sure we can actually use docker as the vagrant user
sudo usermod -aG docker vagrant
sudo docker --version

sudo apt-get install docker-compose -y

for bin in cfssl cfssl-certinfo cfssljson
do
  echo "Installing $bin..."
  curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
  sudo install /tmp/${bin} /usr/local/bin/${bin}
done

SCRIPT

$script2 = <<SCRIPT2

echo "Installing wordpress compose..."

(
cat <<-EOF
[Unit]
Description=%i service with docker compose
Requires=docker.service
After=docker.service

[Service]
Restart=always

WorkingDirectory=/etc/docker/compose/%i

# Remove old containers, images and volumes
ExecStartPre=/usr/bin/docker-compose down -v
ExecStartPre=/usr/bin/docker-compose rm -fv
ExecStartPre=-/bin/bash -c 'docker volume ls -qf "name=%i_" | xargs docker volume rm'
ExecStartPre=-/bin/bash -c 'docker network ls -qf "name=%i_" | xargs docker network rm'
ExecStartPre=-/bin/bash -c 'docker ps -aqf "name=%i_*" | xargs docker rm'

# Compose up
ExecStart=/usr/bin/docker-compose up

# Compose down, remove containers and volumes
ExecStop=/usr/bin/docker-compose down -v

[Install]
WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/docker-compose@.service

sudo mkdir -p /etc/docker/compose/wordpress-stack || exit 0

(
cat <<-EOF2
version: '3'

services:
  db:
    image: mysql:8.0
    container_name: db
    restart: unless-stopped
    env_file: .env
    environment:
      - MYSQL_DATABASE=wordpress
    volumes:
      - dbdata:/var/lib/mysql
    command: '--default-authentication-plugin=mysql_native_password'
    networks:
      - app-network

  wordpress:
    depends_on:
      - db
    image: wordpress:5.1.1-fpm-alpine
    container_name: wordpress
    restart: unless-stopped
    env_file: .env
    environment:
      - WORDPRESS_DB_HOST=db:3306
      - WORDPRESS_DB_USER=$MYSQL_USER
      - WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD
      - WORDPRESS_DB_NAME=wordpress
    volumes:
      - wordpress:/var/www/html
    networks:
      - app-network

  webserver:
    depends_on:
      - wordpress
    image: nginx:1.15.12-alpine
    container_name: webserver
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - wordpress:/var/www/html
      - ./nginx-conf:/etc/nginx/conf.d
      - certbot-etc:/etc/letsencrypt
    networks:
      - app-network

#  certbot:
#    depends_on:
#      - webserver
#    image: certbot/certbot
#    container_name: certbot
#    volumes:
#      - certbot-etc:/etc/letsencrypt
#      - wordpress:/var/www/html
#    command: certonly --webroot --webroot-path=/var/www/html --email sammy@example.com --agree-tos --no-eff-email --staging -d example.com -d www.example.com

volumes:
  certbot-etc:
  wordpress:
  dbdata:

networks:
  app-network:
    driver: bridge

EOF2
) | sudo tee /etc/docker/compose/wordpress-stack/docker-compose.yaml

(
cat <<-EOF3
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_USER=your_wordpress_database_user
MYSQL_PASSWORD=your_wordpress_database_password
EOF3
) | sudo tee /etc/docker/compose/wordpress-stack/.env

sudo systemctl daemon-reload

echo "Starting wordpress compose..."

sudo systemctl restart docker-compose@wordpress-stack

sudo systemctl enable docker-compose@wordpress-stack

SCRIPT2

$script_status = <<SCRIPT3

echo "Showing status of wordpress-stack compose..."

cd /etc/docker/compose/wordpress-stack && docker-compose ps

SCRIPT3

Vagrant.configure(2) do |config|
  config.vm.box = "peru/ubuntu-18.04-server-amd64" # 18.04 LTS
  config.vm.hostname = "wordpress-stack"
  config.vm.define "wordpress-stack"
  config.vm.provision "docker", type: "shell", inline: $script, privileged: false

  config.vm.provision "compose", type: "shell", inline: $script2, privileged: false

  config.vm.provision "status", type: "shell", inline: $script_status, privileged: false

  # Expose http/s port
  config.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true

  config.vm.provider :libvirt do |v|
    v.memory = 1024
    v.cpus = 2
  end
end
