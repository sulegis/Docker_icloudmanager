#!/bin/bash

# build iCM Image
PKGNAME=`wget -qO- ftp://ftp.ispeco.com/icloud/Package_linux_x64_tar/CURRENT | cat`
echo Current_PKG is $PKGNAME
sudo rm ./*.tar.gz
sudo wget -P . ftp://ftp.ispeco.com/icloud/Package_linux_x64_tar/$PKGNAME

sudo docker build -t 192.168.169.114:5000/supermap/icloudmanager:c810 .

# restart iCM Docker-Compose
sudo docker-compose down
sleep 5s
sudo docker-compose up -d

