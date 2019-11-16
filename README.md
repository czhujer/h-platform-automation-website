# H platform automation: website
simple LAMP stack for wordpress with  plugin

# components
- mysql server (https://hub.docker.com/_/mysql)
- nginx     (https://hub.docker.com/_/nginx)
- php-fpm
- wordpress (https://hub.docker.com/_/wordpress/)
  - plugin Calculoid (https://wordpress.org/plugins/calculoid-calculators-builder/#installation)

# docs
- based on https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose
- wordpress CMS https://github.com/WordPress/WordPress

# testing
- vagrant (with libvirt plugin)
- docker engine with docker-compose file

## vagrant commands
single (one) command
```
vagrant up
```
(re-) run commands
```
vagrant provision --provision-with docker-install
vagrant provision --provision-with compose-files,nginx-files,compose-exec
vagrant provision --provision-with bootstrap-wordpress,bootstrap-wordpress-plugins
vagrant provision --provision-with status
```
