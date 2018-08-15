#!/bin/bash
# Getting user paths
source /etc/profile
# Saving name of IoT Hub for later config
echo $1 | tee "/home/$2/.hubName.txt"
# Saving Vm info for later config
curl -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | python -m json.tool > "/home/$2/.vminfo.json"
# Making the IoT Directory
mkdir /home/$2/IoT
chmod 777 /home/$2/IoT
# Installing Edge Config File
dir_path="/home/$2/IoT/IotEdge"
file_path="/home/$2/IoT/IotEdge/edge_configure.sh"
mkdir $dir_path
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/edge_configure.sh > $file_path
chmod 777 $file_path
chmod 777 $dir_path
# Installing IoT Tools and SDKS
# Azures IoT SDKS
mkdir "/home/$2/IoT/IotSDKs"
mkdir "/home/$2/IoT/IotSDKs/Java"
git clone  https://github.com/Azure/azure-iot-sdk-java.git  "/home/$2/IoT/IotSDKs/Java"
mkdir "/home/$2/IoT/IotSDKs/Python"
git clone --recursive https://github.com/Azure/azure-iot-sdk-python.git "/home/$2/IoT/IotSDKs/Python"
## Tensorflow key
curl https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg | sudo apt-key add -
# Installing certificate generation files for gateway
dir_path="/home/$2/IoT/IotEdge/gateway"
mkdir $dir_path
chmod 777 $dir_path
dir_path="/home/$2/IoT/IotEdge/gateway/certificates"
mkdir $dir_path
chmod 777 $dir_path
git clone https://github.com/Azure/azure-iot-sdk-c.git "$dir_path/azure-iot-sdk-c"
file_path="$dir_path/azure-iot-sdk-c/tools/CACertificates/*.cnf"
cp $file_path $dir_path
cp "$dir_path/azure-iot-sdk-c/tools/CACertificates/certGen.sh" $dir_path
chmod 777 "$dir_path/certGen.sh" 
# Installing gateway configuration file
file_path="/home/$2/IoT/IotEdge/gateway/gateway_configure.sh"
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/gateway_configure.sh > $file_path
chmod 777 $file_path
# Installing CLI Extension
az extension add --name azure-cli-iot-ext
# Adding Notebooks 
dir_path="/home/$2/notebooks/IoT"
mkdir $dir_path
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/Notebooks/AzureServices.ipynb > "$dir_path/AzureServices.ipynb"
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/Notebooks/ObtainingIoTData.ipynb > "$dir_path/ObtainingIoTData.ipynb"
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/Notebooks/ProcessingIoTData.ipynb > "$dir_path/ProcessingIoTData.ipynb"
curl https://raw.githubusercontent.com//Azure/DataScienceVM/master/Extensions/Iot/Notebooks/SettingUpEdge.ipynb > "$dir_path/SettingUpEdge.ipynb"
# Adding Container files
dir_path="/home/$2/IoT/IotEdge/gateway/sniffer"
mkdir $dir_path
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/Extractor_Module/main.py > "$dir_path/main.py"
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/Extractor_Module/Dockerfile > "$dir_path/Dockerfile"
curl https://raw.githubusercontent.com/Azure/DataScienceVM/master/Extensions/Iot/Extractor_Module/requirements.txt > "$dir_path/requirements.txt"
# Installing VScode extensions
sudo -u $2 code --install-extension vsciot-vscode.vscode-iot-workbench
sudo -u $2 code --install-extension vsciot-vscode.azure-iot-edge
/usr/share/unattended-upgrades/unattended-upgrade-shutdown &&
# The IoT C SDK works through apt-get
add-apt-repository -y ppa:aziotsdklinux/ppa-azureiot
# Installing Edge Runtime and C Sdk
apt-get update -y
apt install -y iotedge jq  azure-iot-sdk-c-dev
# Updating cli
apt install azure-cli  -y --allow-change-held-packages 