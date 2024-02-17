#!/usr/bin/env bash

set -euo pipefail

function log(){
  # You can use this log function for your pleasure
  printf "\n\n\e[32m ${1} \e[0m\n\n"
}

function logfail(){
  # Use it to log errors with red
  printf "\n\n\e[31m ${1} \e[0m"
}

exit 1
