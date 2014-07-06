#!/usr/bin/env bash
# ./build-fig.sh <www_path>

awk -v www_path="$1" '{ sub("./www", www_path); print }' fig.yml.build > fig.yml