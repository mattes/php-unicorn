# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.4"

################
http_host_ports = {}
http_host_ports["unicorn-http-apache"] = 8080

db_host_ports = {}
db_host_ports["unicorn-db-mysql"] = 3306

www_path = Dir.pwd + "/www"
log_path = Dir.pwd + "/log"
################

Vagrant.configure("2") do |config|

  config.vm.box     = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "php-unicorn"
    vb.memory = 512
  end

  config.vm.synced_folder www_path, "/www"
  config.vm.synced_folder log_path, "/var/host_log"
  
  config.vm.provision "docker" do |d|

    php_versions = ["5.3", "5.4", "5.5"]

    # pull images from https://index.docker.io/u/mattes/
    d.pull_images "mattes/unicorn-db-mysql"
    d.pull_images "mattes/unicorn-http-apache"
    php_versions.each do |version|
      d.pull_images "mattes/unicorn-php-#{version}"
    end
    
    # start containers in the following order ...
    #  1. Databases
    d.run "unicorn-db-mysql",
      image: "mattes/unicorn-db-mysql",
      args: [
        "-name unicorn-db-mysql",
        "-v /var/host_log/db-mysql:/var/log",
        "-p 3306:3306"
      ].join(" ")
    config.vm.network :forwarded_port, :host => db_host_ports['unicorn-db-mysql'], :guest => 3306

    #  2. PHP versions
    php_versions.each do |version|
      d.run "unicorn-php-#{version}",
        image: "mattes/unicorn-php-#{version}",
        args: [
          "-name unicorn-php-#{version}", 
          "-v /www:/www",
          "-v /var/host_log/php-#{version}:/var/log",
          "-link unicorn-db-mysql:db"
        ].join(" ")
    end

    #  3. Web servers
    d.run "unicorn-http-apache",
      image: "mattes/unicorn-http-apache",
      args: [
        "-name unicorn-http-apache",
        "-p 8080:80", # avoid 80, or sudo!
        "-v /www:/www",
        "-v /var/host_log/http-apache:/var/log",
      ].concat(php_versions.map{|version| "-link unicorn-php-#{version}:php_#{version.gsub('.', '_')}"}).join(" ")
    config.vm.network :forwarded_port, :host => http_host_ports["unicorn-http-apache"], :guest => 8080

  end
end