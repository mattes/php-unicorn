PHP Development Environment
===========================

__[Multiple PHP versions (with PHP-FPM)](https://github.com/mattes/php-unicorn/tree/master/php) + [Webserver](https://github.com/mattes/php-unicorn/tree/master/http) + [Database](https://github.com/mattes/php-unicorn/tree/master/db)__


Run PHP versions (5.3, 5.4, 5.5) with PHP-FPM as [docker containers](http://www.docker.io)
and easily switch PHP versions within your webserver.

Apache Example
```
<VirtualHost *>
  VirtualDocumentRoot /www/%0
  Use PHP-5.4 /www/%{SERVER_NAME}
</VirtualHost>
```
nginx @todo


Docker Container Overview
=========================

```
                                +---------- /www data ------------+
                                |                                 |
                              mount                             mount    
                                |                                 |
                                v                                 v
DB (i.e. MySQL 3306) <-link-> PHP 5.3 (PHP-FPM 20053) <-link-> Webserver (i.e. Apache 80)
                              PHP 5.4 (PHP-FPM 20054)
                              PHP 5.5 (PHP-FPM 20055) 
```                          


PHP containers are linked to DB containers, so PHP is able to do ``mysql_connect('127.0.0.1', ..)``. 
Behind the scenes there is some magic ([rinetd](http://www.lenzg.net/rinetd/rinetd.html)) which maps all requests to ``127.0.0.1:3306`` to the actual IP of the DB container. 
Of course, the Webserver is linked to the PHP containers as well. 

Your www data directory is mounted to both, the PHP containers and the Webserver container, under ``/www``.


Setup
=====

### Mac OS X with Boot2docker

__Prerequisites__: [VirtualBox](https://www.virtualbox.org), [boot2docker](http://boot2docker.github.io),
[boot2docker.iso with VirtualBox Guest Additions](https://medium.com/boot2docker-lightweight-linux-for-docker/boot2docker-together-with-virtualbox-guest-additions-da1e3ab2465c),
[fig](http://orchardup.github.io/fig)

```bash
git clone https://github.com/mattes/php-unicorn
cd php-unicorn
boot2docker up
./build-fig.sh ./www
fig up # see fig.yml
open http://<boot2docker-ip>:8080
```

Service | Host | Exposed Docker Container
--------|------|-------------------------
Apache  | 8080 | 80
MySQL   | 3306 | 3306
PHP 5.3 | -    | 20053          
PHP 5.4 | -    | 20054          
PHP 5.5 | -    | 20055     



### Linux

__Prerequisites__: [Docker](http://www.docker.io), [fig](http://orchardup.github.io/fig)

```bash
# see above
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

