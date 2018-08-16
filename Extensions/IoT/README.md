# Welcome to Azure IoT Edge on Data Science Virtual Machine

This tool is an extension to the [Microsoft Azure Data Science Virtual Machine (DSVM)](http://aka.ms/dsvm) to add the Azure IoT Edge capability to bring the power of advanced analytics, machine learning, and artificial intelligence to the edge. The Azure IoT Edge run time will be layered on top of the [Ubuntu edition of the DSVM](http://aka.ms/dsvm/ubuntu),  combining the rich AI and Machine Learning toolset on the DSVM with the capabilities to build applications for the intelligent edge. 

The extension will create an VM provisioned with the IoT Edge runtime, it can be paired to an existing Iot Hub or a new Iot Hub can be created on the deployment for pairing with the VM, inside the Home folder we have included an script for making the Edge device pairing process with Iot Hub pretty straigth forward. 

Click the button below to create a Data Science VM and add-on the IoT Edge Runtime components.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FDataScienceVM%2Fmaster%2FExtensions%2FIoT%2Fazuredeploy.json" target="_blank">
 -    <img src="http://azuredeploy.net/deploybutton.png"/>
 -</a>
