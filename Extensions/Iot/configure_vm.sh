#!/bin/bash
# Getting user paths
source /etc/profile
# Installing JQ
apt-get install -y jq
# Updating Azure CLI 
/anaconda/envs/py35/bin/pip install --upgrade pip
/anaconda/envs/py35/bin/pip install --ignore-installed azure-cli
# Installing Edge Runtime 
apt-get update -y
apt-get install -y iotedge
# Saving name of Iot Hub for later config
echo $1 | tee "/home/$2/.hubName.txt"
# Saving Vm info for later config
curl -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | python -m json.tool > "/home/$2/.vminfo.json"
# Installing Edge Config File
dir_path="/home/$2/IotEdge"
file_path="/home/$2/IotEdge/edge_configure.sh"
mkdir $dir_path
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/edge_configure.sh > $file_path

chmod 777 $file_path
chmod 777 $dir_path

