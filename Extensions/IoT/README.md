# Welcome to Azure IoT Edge on Data Science Virtual Machine

This tool is an extension to the [Microsoft Azure Data Science Virtual Machine (DSVM)](http://aka.ms/dsvm) to add the Azure IoT Edge capability to bring the power of advanced analytics, machine learning, and artificial intelligence to the edge. The Azure IoT Edge run time will be layered on top of the [Ubuntu edition of the DSVM](http://aka.ms/dsvm/ubuntu),  combining the rich AI and Machine Learning toolset on the DSVM with the capabilities to build applications for the intelligent edge. 

The extension will create an VM provisioned with the IoT tools required for developing IoT + DS solutions which includes: 

| Name | Version |
| ---- | ------- |
| Azure IoT SDK - Python | 1.4.2 |
| Azure IoT SDK - C | 1.2.8 |
| Azure IoT SDK - Java | 1.13.3 |
| VS Code IoT Workbench extension | 0.1.9 |
| VS Code IoT Edge extension | 1.2.0  |
| Azure CLI IoT extension | 0.3.2 |
| IoT Edge Runtime | 1.0.1 |


The extension can be paired to an existing Iot Hub or a new Iot Hub can be created on the deployment for pairing with the VM. We have also included scripts to make your set up more quickly and Jupiter notebooks to introduce you to some of the new capabilities of the IoT extension:

| Name | Info | 
| ---- | ---- |
| edge_configure.sh | This script pairs the IoT Rdge runtime to the IoT Hub that you selected during the creation of the extension |
| gateway_configure.sh | This script generates quickstart certificates and inserts the paths into the security daemon of the IoT Edge Runtime in order to transform it into a gateway |
| ObtainingIoTData.ipynb | This notebook explains how can you leverage the included IoT Edge runtime in order to build a sample architecture for processing incoming IoT telemetry inside the virtual machine by using docker containers and docker volumes |
| ProcessingIoTData.ipynb | This notebook explains shows how to run experiments by using incoming telemetry data from the proposed architecture  |
| SettingUpEdge.ipynb | This notebook explains more detailed the included bash scripts for setting up your IoT Edge enviroment |

Click the button below to create a Data Science VM IoT extension.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FDataScienceVM%2Fmaster%2FExtensions%2FIoT%2Fazuredeploy.json" target="_blank">
 -    <img src="http://azuredeploy.net/deploybutton.png"/>
 -</a>
