Click the button below to create a Data Science VM and deploy the tutorial.

[![Deploy to Azure](https://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/)

### Adding SSH Keys to the VMs
After you create the VMs, it may be convenient to create an SSH key pair on one of the machine and add that key to all the DSVMs that you created. This helps with troubleshooting and taking corrective actions during the lab. 

Here are instructions. 

1. Login to one of the Linux DSVM just created. We typically dedicate one of the DSVM for the instructors and proctors. Lets call this the instructor VM.
2. Run the following commands in the bash shell (after you have logged into the AZ CLI):
```
mkdir -o ~/.ssh
cd ~/.ssh
ssh-keygen -t rsa -b 2048 -f <labkey file name>
az vm user update -u <<Initial Username>> --ssh-key-value <<labkey>>.pub  -g <<Resource Group of the VMs>>   --ids $(az vm list -g <<Resource Group of the VMs>>  --query "[].id" -o tsv)
```
3. Now you can login to or run a remote command on other VMs from the instructor VM without any prompts:
```
ssh -o "StrictHostKeyChecking no" <<Username>>@<<DSVM Full Domain Name>> -i <<labkey>>
ssh -o "StrictHostKeyChecking no" <<Username>>@<<DSVM Full Domain Name>> -i <<labkey>> nvidia-smi
```

