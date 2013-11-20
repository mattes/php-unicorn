#!/usr/bin/env bash

function usage {
  printf "Usage: <cmd> <path>\n"
  printf "\n"
  printf "Commands:\n"
  printf "  build         Build Dockerfile\n"
  printf "  build-clean   Delete existing image and build Dockerfile\n"
  printf "\n"
  printf "Examples:\n"
  printf "  ./dockerfile.sh build php/5.4\n"
  printf "  ./dockerfile.sh build-clean http/apache\n"
  printf "\n"
}

cmd=$1
path=$2
docker_user="mattes"

if [[ $path == "" || $cmd == "" ]]; then
  usage && exit 1
fi

if [[ ! -e $path ]]; then
  printf "Error: path does not exist!\n" && usage && exit 1
fi

# replace / with - to create image name
image_name="unicorn-"${path/\//-}

# commands ...
if [[ $cmd == "build" ]]; then
  docker build -rm -t $docker_user/$image_name $(pwd)/$path

elif [[ $cmd == "build-clean" ]]; then
  docker rmi $docker_user/$image_name
  docker build -rm --no-cache -t $docker_user/$image_name $(pwd)/$path
fi