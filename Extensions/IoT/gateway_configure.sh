#!/bin/bash
echo "Note: DO NOT use a name that is the same as the gateway's DNS host name. Doing so will cause client certification against the certificates to fail."
if [ -z ${1+x} ];
then
    echo "Missing parameter: Gateway device name"
    exit 1
fi
# Certificate generation
(cd certificates/; sudo bash certGen.sh create_root_and_intermediate)
(cd certificates/; sudo bash certGen.sh create_edge_device_certificate $1)
# Chain creation
sudo chmod 777 certificates/certs
sudo cat certificates/certs/new-edge-device.cert.pem certificates/certs/azure-iot-test-only.intermediate.cert.pem certificates/certs/azure-iot-test-only.root.ca.cert.pem > certificates/certs/new-edge-device-full-chain.cert.pem
user="$(whoami)"
certdir="/home/$user/IoT/IotEdge/gateway/certificates"
device_ca_cert="  device_ca_cert: $certdir/certs/new-edge-device-full-chain.cert.pem"
device_ca_pk="  device_ca_pk: $certdir/private/new-edge-device.key.pem"
trusted_ca_certs="  trusted_ca_certs: $certdir/certs/azure-iot-test-only.root.ca.cert.pem"
title="certificates:"
sudo sed -i '53s/.*//'  /etc/iotedge/config.yaml
sudo sed -i '54s/.*//'  /etc/iotedge/config.yaml
sudo sed -i '55s/.*//'  /etc/iotedge/config.yaml
sudo sed -i '56s/.*//'  /etc/iotedge/config.yaml
sudo sed -i '53i\'"$title" /etc/iotedge/config.yaml
sudo sed -i '54i\'"$device_ca_cert" /etc/iotedge/config.yaml
sudo sed -i '55i\'"$device_ca_pk" /etc/iotedge/config.yaml
sudo sed -i '56i\'"$trusted_ca_certs" /etc/iotedge/config.yaml
sudo systemctl restart iotedge