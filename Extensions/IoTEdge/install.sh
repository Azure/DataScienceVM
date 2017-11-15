#!/bin/bash
# Install IOT Edge Runtime and register the edge device
source /anaconda/bin/activate
/anaconda/bin/pip install -U azure-iot-edge-runtime-ctl
/anaconda/bin/iotedgectl setup --connection-string $1 --auto-cert-gen-force-no-passwords
/anaconda/bin/iotedgectl start
