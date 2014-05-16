#!/usr/bin/env bash

function usage {
  printf "Usage: <cmd> <image-name>\n"
  printf "\n"
  printf "Commands:\n"
  printf "  build         Build image from Dockerfile\n"
  printf "  rm            Delete image\n"
  printf "  build-clean   Delete existing image and build image from Dockerfile\n"
  printf "\n"
  printf "Examples:\n"
  printf "  ./dockerfile.sh build php-5.4\n"
  printf "  ./dockerfile.sh build-clean http-apache\n"
  printf "\n"
}

cmd=$1
image_name=$2
docker_user="mattes"

# remove prefix unicorn- if necessary
if [[ $image_name =~ "unicorn" ]]; then
  image_name=${image_name/unicorn-//}
fi

# replace - with / to create path
# http-apache becomes http/apache
# php-5.4 becomes php/5.4
path=${image_name/-/\/}

# prefix unicorn- if necessary
if [[ ! $image_name =~ "unicorn" ]]; then
  image_name="unicorn-$image_name"
fi

if [[ ! -e $(pwd)/$path ]]; then
  printf "Error: path for image does not exist!\n\n" && exit 1
fi


# commands ...
if [[ $cmd == "build" ]]; then
  docker build --rm -t $docker_user/$image_name $(pwd)/$path

elif [[ $cmd == "rm" ]]; then
  docker rmi $docker_user/$image_name

elif [[ $cmd == "build-clean" ]]; then
  docker rmi $docker_user/$image_name >/dev/null 2>&1
  docker build --rm --no-cache -t $docker_user/$image_name $(pwd)/$path

else
  printf "Error: unknown command!\n\n" && usage && exit 1
fi
