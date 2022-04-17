#!/bin/bash
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --cores=2 \
  --core-fraction=20 \
  --zone=ru-central1-a \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4,nat-address=51.250.65.124,ipv4-address=10.128.0.33  \
  --metadata serial-port-enable=0 \
  --ssh-key ~/.ssh/appuser.pub
