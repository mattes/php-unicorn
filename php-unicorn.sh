#!/usr/bin/env bash

# create symlink in /usr/local/bin if you want to:
# $ ln -s $(pwd)/php-unicorn.sh /usr/local/bin/puni

# set UNICORN_WWW_PATH environment variable if using symlinks:
# $ export UNICORN_WWW_PATH=/absolute/path/to/your/www/vhosts

###################################################################

www_path=$(pwd)/www   # where all your virtual hosts are
host_http_port="80"   # make this port visible to your host machine
host_db_port="3306"   # make this port visible to your host machine
which_db="mysql"      # name of database service
docker_user="mattes"  # if you dont want to use the default images

###################################################################


function usage {
  printf "Usage: <cmd> [image-name]\n"
  printf "\n"
  printf "Commands:\n"
  printf "  run                     Create (all) container/s\n"
  printf "  run-shell <image-name>  Create and start shell in new container\n"
  printf "  rm                      Stop and delete (all) container/s\n"
  printf "  start                   Start or create (all) container/s\n"
  printf "  stop                    Stop (all) container/s\n"
  printf "  restart                 Restart (all) container/s\n"
  printf "\n"
  printf "Examples:\n"
  printf "  ./php-unicorn.sh start\n"
  printf "  ./php-unicorn.sh stop\n"
  printf "\n"
  printf "  ./php-unicorn.sh start php-5.4\n"
  printf "  ./php-unicorn.sh start http-apache\n"
  printf "  ./php-unicorn.sh restart http-apache\n"
  printf "  ./php-unicorn.sh run-shell db-mysql\n"
  printf "\n"
  printf "Please keep in mind, to start containers in the following order:\n"
  printf "  1. DB containers (i.e. MySQL)\n"
  printf "  2. PHP containers\n"
  printf "  3. Web server containers (i.e. Apache)\n"
  printf "\n"
}


cmd=$1
image_name=$2

if [[ ! -e $www_path ]]; then
  www_path=$UNICORN_WWW_PATH
  if [[ ! -e $www_path ]]; then
    printf "Error: www_path does not exist! Set UNICORN_WWW_PATH environment variable!\n\n" && exit 3
  fi
fi

if [[ ! $image_name ]]; then
  # commands without image name ...
  order=( "db-$which_db" "php-5.3" "php-5.4" "php-5.5" "http-apache" )
  for container in "${order[@]}"; do
    . $(basename $0) $cmd $container
  done

else
  # commands with image name ...

  # prefix unicorn- if necessary
  if [[ ! $image_name =~ "unicorn" ]]; then
    image_name="unicorn-$image_name"
  fi

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
    link_containers="\
      -link unicorn-php-5.3:php_5_3 \
      -link unicorn-php-5.4:php_5_4 \
      -link unicorn-php-5.5:php_5_5"

  elif [[ $image_name =~ "db" ]]; then
    expose_ports="-p $host_db_port:3306"
  fi


  # commands ...
  if [[ $cmd == "run" ]]; then
    docker run \
      $expose_ports \
      $share_dirs \
      $link_containers \
      -d \
      -name $image_name \
      $docker_user/$image_name

  elif [[ $cmd == "run-shell" ]]; then
    docker run \
      $expose_ports \
      $share_dirs \
      $link_containers \
      -i -t \
      -name $image_name \
      $docker_user/$image_name \
      /bin/bash

  elif [[ $cmd == "rm" ]]; then
    docker kill $image_name >/dev/null 2>&1
    docker rm $image_name

  elif [[ $cmd == "stop" ]]; then
    docker stop -t=5 $image_name

  elif [[ $cmd == "start" ]]; then
    docker start $image_name 2>/dev/null || . $(basename $0) run $image_name

  elif [[ $cmd == "restart" ]]; then
    . $(basename $0) stop $image_name
    . $(basename $0) start $image_name

  else
    printf "Error: unknown command!\n\n" && usage && exit 1
  fi
fi

