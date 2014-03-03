PHP Development Environment
===========================

__[Multi PHP versions (with PHP-FPM)](https://github.com/mattes/php-unicorn/tree/master/php) + [Webserver](https://github.com/mattes/php-unicorn/tree/master/http) + [Database](https://github.com/mattes/php-unicorn/tree/master/db)__


Run different PHP versions in [docker](http://www.docker.io) containers and 
easily switch them within your webserver. [Vagrant](http://www.vagrantup.com) does all the container
configuration for you.

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

__Prerequisites__

 * [VirtualBox](https://www.virtualbox.org)
 * [Vagrant](http://www.vagrantup.com)

```bash
git clone https://github.com/mattes/php-unicorn
cd php-unicorn
vagrant up
open http://localhost:8080 # if this doesn't work, check log directory for errors
```


Usage
=====
```bash
vagrant up
vagrant halt
vagrant reload --provision # when Vagrantfile is updated
```

Build Custom Docker Containers
==============================

You can build your own docker containers. Check the ``./dockerfile.sh`` helper.


Next steps
==========

 * Apache: Learn how the ``Use PHP-5.x`` macros work. See [php-macros.conf](https://github.com/mattes/php-unicorn/blob/master/http/apache/php-macros.conf) and [start.sh](https://github.com/mattes/php-unicorn/blob/master/http/apache/start.sh).
 * Apache: Customize a VirtualHost with a new configuration file ```IncludeOptional /www/*.a2.conf```. See [001-multi-virtualhosts.conf](https://github.com/mattes/php-unicorn/blob/master/http/apache/001-multi-virtualhosts.conf).


Further Readings
================
 * https://wiki.php.net/rfc/releaseprocess
 * http://docs.docker.io/en/latest/examples/linking_into_redis/
 * [Test PHP-FPM connections](https://gist.github.com/mattes/7488172)
 * https://www.google.com/search?q=public+wildcard+domain+127.0.0.1
 * http://stackoverflow.com/questions/1562954/public-wildcard-domain-name-to-resolve-to-127-0-0-1

