#!/usr/bin/env bash

cmd=$1

# commands ...
if [[ $cmd == "build" ]]; then
  docker build -rm -t mattes/mysql $(pwd)

elif [[ $cmd == "build-clean" ]]; then
  docker rmi mattes/mysql
  docker build -rm --no-cache -t mattes/mysql $(pwd)
fi