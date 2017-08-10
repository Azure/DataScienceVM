# Creating a DSVM for Linux (Ubuntu)

These directions show you how to create an Ubuntu DSVM using the portal or the Azure CLI.

## Creating a DSVM for Linux (Ubuntu) from the portal

### Deploy a DSVM for Linux (Ubuntu) with password authentication using the portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FDataScienceVM%2Fmaster%2FScripts%2FCreateDSVM%2FUbuntu%2Fazuredeploy.json" target="_blank">
 -    <img src="http://azuredeploy.net/deploybutton.png"/>
 -</a>


### Deploy a DSVM for Linux (Ubuntu) with SSH key-based authentication using the portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FDataScienceVM%2Fmaster%2FScripts%2FCreateDSVM%2FUbuntu%2Fazuredeploysshkey.json" target="_blank">
 -    <img src="http://azuredeploy.net/deploybutton.png"/>
 -</a>


## Creating a DSVM for Linux (Ubuntu) using the command line

These steps show you how to create a Ubuntu DSVM using Azure CLI Version 2 with an ARM template. You need the [Azure CLI 2.0](https://docs.microsoft.com/cli/azure/install-az-cli2) on your desktop/laptop/VM. The DSVM automatically comes preinstalled with Azure CLI 2.0.

These instructions use the azuredeploy.json template, which uses password authentication. Use the azuredeploysshkey.json template if you want SSH key-based authentication instead.

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
Replace the parameters with values you will use for your new DSVM you are creating. A list of allowed vmSize is found in the [Ubuntu DSVM ARM template](azuredeploy.json). 

Step 2: Use Azure CLI to create the VM

    # Follow instructions of az login to signin to your Azure account. May need to select subscription if you have multiple subscriptions
    az login
    az group create --name [[NAME OF RESOURCE GROUP]] --location [[ Data center. For eg: "West US 2"]
    az group deployment create --resource-group  [[NAME OF RESOURCE GROUP ABOVE]]  --template-uri https://raw.githubusercontent.com/Azure/DataScienceVM/master/Scripts/CreateDSVM/Ubuntu/azuredeploy.json --parameters @[[PARAMETER JSON FILE]]
    
## Creating multiple instances of DSVM for Linux (Ubuntu) using command line and execute a post install script on the VM Instance

To create multiple Ubuntu DSVMs in one shot using Azure CLI Version 2, use the steps below. These use the ARM template multiazuredeploywithext.json. This also executes a post install bash script that can configure the VM to your needs or install any additional packages you want on the VM. 

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
Replace the parameters with values you will use for your new DSVM you are creating. A list of allowed vmSize is found in the [Ubuntu DSVM ARM template](multiazuredeploywithext.json). 

Step 2: Use the following Azure CLI to create VM(s)

    # Follow instructions of az login to signin to your Azure account. May need to select subscription if you have multiple
    az login
    az group create --name [[NAME OF RESOURCE GROUP]] --location [[ Data center. For eg: "West US 2"]
    az group deployment create --resource-group  [[NAME OF RESOURCE GROUP ABOVE]]  --template-uri https://raw.githubusercontent.com/Azure/DataScienceVM/master/Scripts/CreateDSVM/Ubuntu/multiazuredeploywithext.json --parameters @[[PARAMETER JSON FILE]]