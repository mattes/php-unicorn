#!/usr/bin/env bash


docker_user="mattes"  # if you dont want to use the default images
www_path=$(pwd)/www   # where all your virtual hosts are
host_http_port="80"   # make this port visible to your host machine
host_db_port="3306"   # make this port visible to your host machine
which_db="mysql"      # name of database service

# ------------



function usage {
  printf "Usage: docker.sh <path> <cmd>\n"
  printf "\nCommands:\n"
  printf "  create         Create Container\n"
  printf "  create-shell   Create and start shell in Container\n"
  printf "  kill           Stop and delete Container\n"
  printf "  re-create      Stop, delete and create new Container\n"
  printf "\nExamples:\n"
  printf "  ./docker.sh php/5.4 start\n"
  printf "  ./docker.sh http/apache start\n"
  printf "\n"
  printf "Please create web server (apache) containers\n"
  printf "AFTER PHP containers.\n\n"
}

path=$1
cmd=$2

if [[ $path == "" || $cmd == "" ]]; then
  usage && exit 1
fi

if [[ ! -e $path ]]; then
  printf "Error: path does not exist!\n\n" && exit 1
fi

# replace / with - to create image name
image_name="unicorn-"${path/\//-}

# set defaults
expose_ports=""
share_dirs=""
link_containers=""
pre_create_check=""

# config services ...
if [[ $path =~ "php" ]]; then
  php_fpm_port=200$(echo $path | sed -e 's/[^0-9]*//g')
  expose_ports="-expose $php_fpm_port"
  share_dirs="-v $www_path:/www"
  link_containers="-link unicorn-db-$which_db:db"
  pre_create_check="docker ps | grep unicorn-db-$which_db && printf \"Error: start unicorn-db-$which_db first\!\" && exit 2"
  
elif [[ $path =~ "http" ]]; then
  expose_ports="-p $host_http_port:80"
  share_dirs="-v $www_path:/www"
  link_containers="-link php-5.3:php-5.3 -link php-5.4:php-5.4 -link php-5.5:php-5.5"

elif [[ $path =~ "db" ]]; then
  expose_ports="-p $host_db_port:3306"
fi


function check_if_links_are_running {
  for item in $(echo $* | tr " " "\n"); do
    case "$item" in
    *"php-5.3"*) docker ps | grep unicorn-php-5.3 || (printf "Error: start unicorn-php-5.3 container first!\n\n" || exit 2);;
    *"php-5.4"*) docker ps | grep unicorn-php-5.4 || (printf "Error: start unicorn-php-5.4 container first!\n\n" || exit 2);;
    *"php-5.5"*) docker ps | grep unicorn-php-5.5 || (printf "Error: start unicorn-php-5.5 container first!\n\n" || exit 2);;
    *db*) docker ps | grep unicorn-db-$which_db || (printf "Error: start unicorn-db-$which_db container first!\n\n" && exit 2);;
    esac
  done
}

# commands ...
if [[ $cmd == "create" ]]; then
  check_if_links_are_running $link_containers || exit 2
  docker run \
    $expose_ports \
    $share_dirs \
    $link_containers \
    -d \
    -name $image_name \
    $docker_user/$image_name

elif [[ $cmd == "create-shell" ]]; then
  check_if_links_are_running $link_containers || exit 2
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
  ./docker.sh $path stop
  ./docker.sh $path start
else
  printf "Error: unknown command!\n\n" && usage && exit 1
fi