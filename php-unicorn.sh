#!/usr/bin/env bash

# create symlink in /usr/local/bin if you want to
# ln -s $(pwd)/php-unicorn.sh /usr/local/bin/puni


docker_user="mattes"  # if you dont want to use the default images
www_path=$(pwd)/www   # where all your virtual hosts are
host_http_port="80"   # make this port visible to your host machine
host_db_port="3306"   # make this port visible to your host machine
which_db="mysql"      # name of database service

# ------------



function usage {
  printf "Usage: unicorn-<image-name> <cmd>\n"
  printf "\nCommands:\n"
  printf "  create         Create Container\n"
  printf "  create-shell   Create and start shell in Container\n"
  printf "  kill           Stop and delete Container\n"
  printf "  re-create      Stop, delete and create new Container\n"
  printf "\nExamples:\n"
  printf "  ./php-unicorn.sh php/5.4 start\n"
  printf "  ./php-unicorn.sh http/apache start\n"
  printf "\n"
  printf "Please create web server (apache) containers\n"
  printf "AFTER PHP containers.\n\n"
}


cmd=$2
$image_name="unicorn-$image_name"

# set defaults
expose_ports=""
share_dirs=""
link_containers=""
pre_create_check=""

# config services ...
if [[ $image_name =~ "php" ]]; then
  php_fpm_port=200$(echo $image_name | sed -e 's/[^0-9]*//g')
  expose_ports="-expose $php_fpm_port"
  share_dirs="-v $www_path:/www"
  link_containers="-link unicorn-db-$which_db:db"
  
elif [[ $image_name =~ "http" ]]; then
  expose_ports="-p $host_http_port:80"
  share_dirs="-v $www_path:/www"
  link_containers="-link unicorn-php-5.3:php_5_3 -link unicorn-php-5.4:php_5_4 -link unicorn-php-5.5:php_5_5"

elif [[ $image_name =~ "db" ]]; then
  expose_ports="-p $host_db_port:3306"
fi


# commands ...
if [[ $cmd == "create" ]]; then
  docker run \
    $expose_ports \
    $share_dirs \
    $link_containers \
    -d \
    -name $image_name \
    $docker_user/$image_name

elif [[ $cmd == "create-shell" ]]; then
  docker run \
    $expose_ports \
    $share_dirs \
    $link_containers \
    -i -t \
    -name $image_name \
    $docker_user/$image_name \
    /bin/bash

elif [[ $cmd == "kill" ]]; then
  docker kill $image_name
  docker rm $image_name

elif [[ $cmd == "re-create" ]]; then
  ./docker.sh $image_name stop
  ./docker.sh $image_name start
else
  printf "Error: unknown command!\n\n" && usage && exit 1
fi