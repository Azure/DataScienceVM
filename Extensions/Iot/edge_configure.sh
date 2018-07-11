#!/bin/bash
# Installing extension
az extension add --name azure-cli-iot-ext
# CLI Login
az login --use-device-code
# Register edge device 
user="$(whoami)"
hubName="$(cat /home/$user/.hubName.txt)"
host="$(hostname)"
device="${host}_edge"
az iot hub device-identity create --device-id $device --hub-name $hubName --edge-enabled
## Inserting connection string into config file
connection_string="$(az iot hub device-identity show-connection-string --device-id $device --hub-name $hubName )"
connection_string="${connection_string::-2}"
connection_string="${connection_string:10}"
connection_string="  device_connection_string: $connection_string"
sudo sed -i '26s/.*//'  /etc/iotedge/config.yaml
sudo sed -i '26i\'"$connection_string" /etc/iotedge/config.yaml
## Reboting edge for pairing to proceed
sudo systemctl restart iotedge