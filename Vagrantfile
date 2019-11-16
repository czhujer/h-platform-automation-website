# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "peru/ubuntu-18.04-server-amd64" # 18.04 LTS
  config.vm.hostname = "wordpress-stack"
  config.vm.define "wordpress-stack"

  config.vm.synced_folder '.', '/vagrant', type: 'sshfs'

  config.vm.provision "docker-install", type: "shell", path: 'scripts/bootstrap-docker.sh', privileged: false

  config.vm.provision "compose-files",
    type: "shell",
    :inline => "mkdir -p /etc/docker/compose/wordpress-stack && cp /vagrant/docker-files/wordpress-stack.yaml /etc/docker/compose/wordpress-stack/docker-compose.yaml",
    :privileged => true

  config.vm.provision "nginx-files",
    type: "shell",
    :inline =>  "mkdir -p /etc/docker/compose/wordpress-stack/nginx-conf; cp /vagrant/nginx-conf/nginx.conf /etc/docker/compose/wordpress-stack/nginx-conf/nginx-all.conf",
    :privileged => true

  config.vm.provision "compose-exec",
    type: "shell",
    path: 'scripts/docker-compose-exec.sh',
    args: ["wordpress-stack"],
    :privileged => true

  config.vm.provision "bootstrap-wordpress",
    type: "shell",
    path: 'scripts/bootstrap-wordpress.sh',
    #args: ["wordpress-stack"],
    :privileged => true

$script_status = <<SCRIPT3
echo "Showing status of wordpress-stack compose..."
cd /etc/docker/compose/wordpress-stack && docker-compose ps
SCRIPT3

  config.vm.provision "status", type: "shell", inline: $script_status, privileged: false

  # Expose http/s port
  config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true

  config.vm.provider :libvirt do |v|
    v.memory = 1024
    v.cpus = 2
  end
end
