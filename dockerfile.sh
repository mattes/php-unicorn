#!/usr/bin/env bash

function usage {
  printf "Usage: dockerfile.sh <path> <cmd>\n"
  printf "\nCommands:\n"
  printf "  build         Build Dockerfile\n"
  printf "  build-clean   Delete existing image and build Dockerfile\n"
  printf "\nExamples:\n"
  printf "  ./dockerfile.sh php/5.4 build\n"
  printf "  ./dockerfile.sh http/apache build-clean\n\n"
}

path=$1
cmd=$2
docker_user="mattes"

if [[ $path == "" || $cmd == "" ]]; then
  usage && exit 1
fi

if [[ ! -e $path ]]; then
  printf "Error: path does not exist!\n" && usage && exit 1
fi

# replace / with - to create image name
image_name=${path/\//-}

# commands ...
if [[ $cmd == "build" ]]; then
  docker build -rm -t $docker_user/$image_name $(pwd)/$path

elif [[ $cmd == "build-clean" ]]; then
  docker rmi $docker_user/$image_name
  docker build -rm --no-cache -t $docker_user/$image_name $(pwd)/$path
fi