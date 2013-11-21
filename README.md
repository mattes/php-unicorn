PHP Development Environment
===========================

__[PHP (PHP-FPM)](https://github.com/mattes/php-unicorn/tree/master/php) + [Webserver](https://github.com/mattes/php-unicorn/tree/master/http) + [Database](https://github.com/mattes/php-unicorn/tree/master/db) ... with [Docker](http://www.docker.io)__

Run every PHP version in a docker container and easily switch PHP
versions within your webserver.

Apache Example
```
<VirtualHost *>
  VirtualDocumentRoot /www/%0
  Use PHP-5.4 /www/%{SERVER_NAME}
</VirtualHost>
```
nginx @todo


Installation
============

```bash
# clone repository 
cd ~/Developer
git clone https://github.com/mattes/php-unicorn
cd php-unicorn

# create symlink for the utility helper
ln -s $(pwd)/php-unicorn.sh /usr/local/bin/puni

# set UNICORN_WWW_PATH environment variable (add this line to your dotfiles)
# export UNICORN_WWW_PATH=$(pwd)/www

# download pre-build unicorn docker images
docker pull mattes/unicorn-php-5.3
docker pull mattes/unicorn-php-5.4
docker pull mattes/unicorn-php-5.5
docker pull mattes/unicorn-http-apache
docker pull mattes/unicorn-db-mysql

# ... or build them yourself with the help of ./dockerfile.sh
```

__Vagrantfile/ VirtualBox Users__: Please modify your docker's Vagrantfile ...

```ruby
...
Vagrant::VERSION >= "1.1.0" and Vagrant.configure("2") do |config|
  ...
  # add the following line to forward ports 
  config.vm.network :forwarded_port, :host => 8080, :guest => 80
  config.vm.network :forwarded_port, :host => 33066, :guest => 3306

  # add the following line to share your virtual hosts files
  # from your local machine with VirtualBox (edit first path accordingly)
  config.vm.synced_folder "/Users/mattes/Developer/php-unicorn/www", "/www"
  ...
```



Usage
=====
```bash
# start containers
puni start
# now open http://localhost or http://localhost:8080 depending on your setup

# stop/ restart
puni stop
puni restart http-apache

# see more commands
puni
```

php-unicorn.sh/ puni is just a small helper. You can of course call all 
plain docker commands yourself.


Next steps
==========

 * Apache: Learn how the ``Use PHP-5.x`` macros work. See [php-macros.conf](https://github.com/mattes/docker-php-fpm/blob/master/http/apache/php-macros.conf).
 * Apache: Customize a VirtualHost with a new configuration file ```IncludeOptional /www/*.a2.conf```. See [001-multi-virtualhosts.conf](https://github.com/mattes/docker-php-fpm/blob/master/http/apache/001-multi-virtualhosts.conf).


Further Readings
================
 * https://wiki.php.net/rfc/releaseprocess
 * http://docs.docker.io/en/latest/examples/linking_into_redis/
 * [Test PHP-FPM connections](https://gist.github.com/mattes/7488172)
 * https://www.google.com/search?q=public+wildcard+domain+127.0.0.1
 * http://stackoverflow.com/questions/1562954/public-wildcard-domain-name-to-resolve-to-127-0-0-1

