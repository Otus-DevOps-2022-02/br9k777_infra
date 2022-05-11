#!/bin/bash
yc compute instance create \
  --name reddit-app-packer \
  --hostname reddit-app-packer \
  --memory=4 \
  --cores=2 \
  --core-fraction=20 \
  --zone=ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4,nat-address=51.250.65.124,ipv4-address=10.128.0.7 \
  --zone ru-central1-a \
  --create-boot-disk name=disk1,size=10,image-id=fd8rd07a577d8u2pje9s \
  --metadata serial-port-enable=1 \
  --metadata-from-file network=./netowrks.yaml \
  --metadata-from-file user-data=./users.yaml


#
#yc compute instance remove-one-to-one-nat reddit-app --network-interface-index 0
#yc compute instance add-one-to-one-nat reddit-app --network-interface-index 0 --nat-address 51.250.65.124 --nat-ip-version ipv4 --internal-address 10.128.0.33
