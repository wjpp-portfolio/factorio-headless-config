#!/bin/bash
#with reference to https://gist.github.com/Igneous01/f045b83929fb0ad0e72e6901dfe99830


#download factorio binary
wget -O factorio_headless.tar.gz https://factorio.com/get-download/stable/headless/linux64

#extract to /opt
sudo tar xvf factorio_headless.tar.gz -C /opt

#remove downloaded archive
rm ~/factorio_headless.tar.gz

#create saves directory
sudo mkdir /opt/factorio/saves

#create factorio user
sudo useradd -M factorio

#give factorio user access to /opt
sudo chown -R factorio:factorio /opt/factorio

#give ec2_user access to /opt for scp transfers
sudo chmod 777 -R /opt

sudo mv server-settings.json /opt/factorio/data/server-settings.json
sudo mv map-settings.json /opt/factorio/data/map-settings.json
sudo mv map-gen-settings.json /opt/factorio/data/map-gen-settings.json

#move factorio service to correct location
sudo mv factorio.service /etc/systemd/system

#start service
sudo systemctl daemon-reload
sudo systemctl enable factorio.service
