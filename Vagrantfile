# -*- mode: ruby -*-
# vi: set ft=ruby :

#in case you have problem(s) with "vagrant up", use main vagrantfile in repo h-platform-automation-infrastructure

Vagrant.configure(2) do |config|
  config.vm.define :"wordpress-stack" do |config_wordpress|
    config_wordpress.vm.box = "peru/ubuntu-20.04-server-amd64"
    config_wordpress.vm.hostname = "wordpress-stack"
    config_wordpress.vm.define "wordpress-stack"

    dir_wordpress = File.expand_path("..", __FILE__)
    puts "DIR wordpress: #{dir_wordpress}"

    config_wordpress.vm.synced_folder dir_wordpress, '/vagrant', type: 'sshfs'

    config_wordpress.vm.provision "docker-install", type: "shell", path: File.join(dir_wordpress,'scripts/bootstrap-docker.sh'), privileged: false

    config_wordpress.vm.provision "compose-files",
      type: "shell",
      :inline => "mkdir -p /etc/docker/compose/wordpress-stack && cp /vagrant/docker-files/wordpress-stack.yaml /etc/docker/compose/wordpress-stack/docker-compose.yaml",
      :privileged => true

    config_wordpress.vm.provision "nginx-files",
      type: "shell",
      :inline =>  "mkdir -p /etc/docker/compose/wordpress-stack/nginx-conf; cp /vagrant/nginx-conf/nginx.conf /etc/docker/compose/wordpress-stack/nginx-conf/nginx-all.conf",
      :privileged => true

    config_wordpress.vm.provision "compose-exec",
      type: "shell",
      path: File.join(dir_wordpress,'scripts/docker-compose-exec.sh'),
      :privileged => true

    config_wordpress.vm.provision "bootstrap-wordpress",
      type: "shell",
      path: File.join(dir_wordpress,'scripts/bootstrap-wordpress.sh'),
      :privileged => true

    config_wordpress.vm.provision "bootstrap-wordpress-plugins",
      type: "shell",
      path: File.join(dir_wordpress,'scripts/bootstrap-wordpress-plugins.sh'),
      :privileged => true

$script_status = <<SCRIPT3
echo "Showing status of wordpress-stack compose..."
cd /etc/docker/compose/wordpress-stack && docker-compose ps
SCRIPT3

    config_wordpress.vm.provision "status", type: "shell", inline: $script_status, privileged: true

    # Expose http/s port
    config_wordpress.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true

    config_wordpress.vm.provider :libvirt do |v|
      v.memory = 1024
      v.cpus = 2
    end
  end
end
