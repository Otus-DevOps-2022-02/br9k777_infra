#!/bin/bash

sudo apt install --assume-yes git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
echo -e "\t\t\033[0;32;1m check reddit process:\033[0m"
ps aux | grep --color puma
