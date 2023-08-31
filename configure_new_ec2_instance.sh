#!/bin/bash
#with reference to https://gist.github.com/Igneous01/f045b83929fb0ad0e72e6901dfe99830


#download factorio binary
wget -O factorio_headless.tar.gz https://factorio.com/get-download/stable/headless/linux64

#extract to /opt
sudo tar xvf factorio_headless.tar.gz -C /opt

#remove downloaded archive
rm ~/factorio_headless.tar.gz

#create factorio user
sudo useradd -M factorio

#give factorio user access to /opt
sudo chown -R factorio:factorio /opt/factorio

#give ec2_user access to /opt for scp transfers
sudo chmod 777 -R /opt
