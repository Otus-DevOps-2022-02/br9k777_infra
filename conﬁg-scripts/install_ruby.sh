#!/bin/bash

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
echo -e "\t\t\033[0;32;1m result install ruby: $(ruby -v) $(bundler -v)\033[0m"
