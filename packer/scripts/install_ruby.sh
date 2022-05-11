#!/bin/bash

sleep 5
apt update
sleep 5
echo -e "\t\t\033[0;34;1m try apt install -y ruby-full\033[0m"
apt install -y ruby-full
sleep 5
echo -e "\t\t\033[0;34;1m try apt install -y ruby-bundler\033[0m"
apt install -y ruby-bundler
sleep 5
echo -e "\t\t\033[0;34;1m try apt install -y build-essential\033[0m"
apt install -y build-essential
echo -e "\t\t\033[0;34;1m result install ruby: $(ruby -v) $(bundler -v)\033[0m"
