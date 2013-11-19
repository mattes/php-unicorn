<?php
ini_set('display_errors', '1');

/*

http://us1.php.net/function.mysql-connect
Whenever you specify "localhost" or "localhost:port" as server, 
the MySQL client library will override this and try to connect 
to a local socket (named pipe on Windows). If you want to use TCP/IP, 
use "127.0.0.1" instead of "localhost". If the MySQL client library 
tries to connect to the wrong local socket, you should set the correct 
path as in your PHP configuration and leave the server field blank.

tl:dr always use 127.0.0.1 instead of localhost !

*/

$link = mysql_connect('127.0.0.1', 'root', 'root');
if (!$link) {
    die('Error: Connection failed: ' . mysql_error());
}
echo 'Success: Connected to MySQL';
mysql_close($link);