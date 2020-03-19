#!/bin/bash
# Script to create Azure DSVM Spot instance with NVidia K80 GPU and install fast.ai library
read -p "Azure VM Name (default: fastai2): " vminput
vmname=${vminput:=fastai2}
while [ $password != $password2 ] ; do 
read -s -p "Choose your Password: " password
echo
read -s -p "Re-enter Password: " password2
echo
done

az group create --name $vmname -l westus2

echo "Creating Azure Data Science VM $vmname..."
# You can change the size parameter if you want something other than NVidia K80 GPU instance. 
# You can find Azure size labels by running Azure CLI command in Cloud Shell "az vm list-sizes -l westus2 -o table"  
az vm create --name $vmname -g $vmname --image microsoft-dsvm:ubuntu-1804:1804:latest  --priority Low --size Standard_NC6 --eviction-policy Deallocate --storage-sku StandardSSD_LRS --admin-user fastuser --admin-password $password
az vm open-port --name $vmname -g $vmname --port 8000
echo "Installing  fastai v2 and notebooks..."
az vm extension set --resource-group $vmname --vm-name $vmname --name customScript --publisher Microsoft.Azure.Extensions --protected-settings '{"fileUris": ["https://raw.githubusercontent.com/Azure/DataScienceVM/master/Samples/fastai2/installfastai2.sh"],"commandToExecute": "./installfastai2.sh"}'
az vm list-ip-addresses -g $vmname -n $vmname -o table
echo "You can now login to VM with SSH or use Jupyterhub by visiting https://[[public IP address above]]:8000/ (Ignore self signed cert warnings)"
echo "Login userid is 'fastuser' with password you entered above"
