This directory will contain scripts and ARM templates to create DSVM with different configurations. 

Here is some helpful tips. 

## Creating DSVM from command line

Pre-requisites: You need Azure CLI 2.0 on your desktop/laptop/VM. You can download it from [here](https://docs.microsoft.com/cli/azure/install-az-cli2). [DSVM automatically comes preinstalled with Azure CLI]

### Creating a DSVM for Linux (Ubuntu) using command line:

To create a Ubuntu DSVM using Azure CLI Version 2 (ARM template - azuredeploy.json available in the CreateDSVM/Ubuntu directory and used below) use the steps below.

Step 1: Create a Parameter file (JSON) for the DSVM you are going to deploy. The file looks like this:

````
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
     "adminUsername": { "value" : "YOURUSERNAME FOR NEW DSVM"},
     "adminPassword": { "value" : "PASSWORD FOR NEW DSVM"},
     "vmName": { "value" : "HOSTNAME OF DSVM"},
     "vmSize": { "value" : "VM SIZE For eg: Standard_DS2_v2"}
  }
}
````
Replace the parameters with values you will use for your new DSVM you are creating. A list of allowed vmSize is found in the [Ubuntu DSVM ARM template](CreateDSVM/Ubuntu/azuredeploy.json). 

Step 2: Use Azure CLI to create the VM

    # Follow instructions of az login to signin to your Azure account. May need to select subscription if you have multiple
    az login
    az group create --name [[NAME OF RESOURCE GROUP]] --location [[ Data center. For eg: "West US 2"]
    az group deployment create --resource-group  [[NAME OF RESOURCE GROUP ABOVE]]  --template-uri https://raw.githubusercontent.com/Azure/DataScienceVM/master/Scripts/CreateDSVM/Ubuntu/azuredeploy.json --parameters @[[PARAMETER JSON FILE]]
    
### Creating a DSVM for Windows using command line:

To create a Windows DSVM using Azure CLI Version 2 (ARM template - azuredeploy.json available in the CreateDSVM/Windows2012 directory and used below) use the steps below.


Step 1: Create a Parameter file (JSON) for the DSVM you are going to deploy. The file looks like this:

````
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
     "adminUsername": { "value" : "YOURUSERNAME FOR NEW DSVM"},
     "adminPassword": { "value" : "PASSWORD FOR NEW DSVM"},
     "vmName": { "value" : "HOSTNAME OF DSVM"},
     "vmSize": { "value" : "VM SIZE For eg: Standard_DS2_v2"}
  }
}
````
Replace the parameters with values you will use for your new DSVM you are creating. A list of allowed vmSize is found in the [Windows DSVM ARM template](CreateDSVM/Windows2012/azuredeploy.json). 

Step 2: Use Azure CLI to create the VM

    # Follow instructions of az login to signin to your Azure account. May need to select subscription if you have multiple
    az login
    az group create --name [[NAME OF RESOURCE GROUP]] --location [[ Data center. For eg: "West US 2"]
    az group deployment create --resource-group  [[NAME OF RESOURCE GROUP ABOVE]]  --template-uri https://raw.githubusercontent.com/Azure/DataScienceVM/master/Scripts/CreateDSVM/Windows2012/azuredeploy.json --parameters @[[PARAMETER JSON FILE]]

### Creating multiple instances of DSVM for Linux (Ubuntu) using command line and execute a post install script on the VM Instance

To create multiple Ubuntu DSVMs in one shot using Azure CLI Version 2 (ARM template - multiazuredeploywithext.json available in the CreateDSVM/Ubuntu directory and used below) use the steps below. This also executes a post install bash script that can configure the VM to your needs or install any additional packages you want on the VM. 

Step 1: Create a Parameter file (JSON) for the DSVM you are going to deploy. The file looks like this:

````
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
     "adminUsername": { "value" : "YOURUSERNAME FOR NEW DSVM"},
     "adminPassword": { "value" : "PASSWORD FOR NEW DSVM"},
     "vmName": { "value" : "HOSTNAME OF DSVM"},
     "vmSize": { "value" : "VM SIZE For eg: Standard_DS2_v2"},
     "fileUris": { "value" : "PUBLIC URL CONTAINING YOUR POST INSTALL BASH SCRIPT PACKAGE"},
     "commandToExecute": { "value" : "SCRIPT FILE <any arguments to script>"},
     "numberOfInstances": { "value" : "NUMBER OF VM INSTANCES TO CREATE"}	      
  }
}
````
Replace the parameters with values you will use for your new DSVM you are creating. A list of allowed vmSize is found in the [Ubuntu DSVM ARM template](CreateDSVM/Ubuntu/multiazuredeploywithext.json). 

Step 2: Use the following Azure CLI to create VM(s)

    # Follow instructions of az login to signin to your Azure account. May need to select subscription if you have multiple
    az login
    az group create --name [[NAME OF RESOURCE GROUP]] --location [[ Data center. For eg: "West US 2"]
    az group deployment create --resource-group  [[NAME OF RESOURCE GROUP ABOVE]]  --template-uri https://raw.githubusercontent.com/Azure/DataScienceVM/master/Scripts/CreateDSVM/Ubuntu/multiazuredeploywithext.json --parameters @[[PARAMETER JSON FILE]]

### Creating multiple instances of DSVM for Windows 2012 using command line and execute a post install script on the VM Instance

To create multiple Windows 2012 DSVMs in one shot using Azure CLI Version 2 (ARM template - multiazuredeploywithext.json available in the CreateDSVM/Windows2012 directory and used below) use the steps below. This also executes a post install Powershell script that can configure the VM to your needs or install any additional packages you want on the VM. 

Step 1: Create a Parameter file (JSON) for the DSVM you are going to deploy. The file looks like this:

````
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
     "adminUsername": { "value" : "YOURUSERNAME FOR NEW DSVM"},
     "adminPassword": { "value" : "PASSWORD FOR NEW DSVM"},
     "vmName": { "value" : "HOSTNAME OF DSVM"},
     "vmSize": { "value" : "VM SIZE For eg: Standard_DS2_v2"},
     "fileUris": { "value" : "PUBLIC URL CONTAINING YOUR POST INSTALL BASH SCRIPT PACKAGE"},
     "commandToExecute": { "value" : "POWERSHELL SCRIPT FILE <any arguments to script>"},
     "numberOfInstances": { "value" : "NUMBER OF VM INSTANCES TO CREATE"}	      
  }
}
````
Replace the parameters with values you will use for your new DSVM you are creating. A list of allowed vmSize is found in the [Windows 2012 DSVM ARM template](CreateDSVM/Windows2012/multiazuredeploywithext.json). 

Step 2: Use the following Azure CLI to create VM(s)

    # Follow instructions of az login to signin to your Azure account. May need to select subscription if you have multiple
    az login
    az group create --name [[NAME OF RESOURCE GROUP]] --location [[ Data center. For eg: "West US 2"]
    az group deployment create --resource-group  [[NAME OF RESOURCE GROUP ABOVE]]  --template-uri https://raw.githubusercontent.com/Azure/DataScienceVM/master/Scripts/CreateDSVM/Windows2012/multiazuredeploywithext.json --parameters @[[PARAMETER JSON FILE]]
