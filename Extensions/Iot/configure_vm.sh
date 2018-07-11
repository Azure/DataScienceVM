#!/bin/bash
# Getting user paths
source /etc/profile
# Updating Azure CLI 
/anaconda/envs/py35/bin/pip install --upgrade pip
/anaconda/envs/py35/bin/pip install --ignore-installed azure-cli
# Installing Edge Runtime 
apt-get update -y
apt-get install -y iotedge
# Saving name of Iot Hub for later config
echo $1 | tee "/home/$2/.hubName.txt"
# Installing Edge Config File
dir_path="/home/$2/IotEdge"
file_path="/home/$2/IotEdge/edge_configure.sh"
mkdir $dir_path
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/edge_configure.sh > $file_path