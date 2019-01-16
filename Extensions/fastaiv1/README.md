# Fast.AI extension for the Azure Data Science Virtual Machine

This tool is an extension to the [Microsoft Azure Data Science Virtual Machine (DSVM)](http://aka.ms/dsvm) to enable working with the [fastai Python library Version 1.x](http://docs.fast.ai/) and run the popular [fast.ai online deep learning course](https://www.fast.ai/) based on this library and [Pytorch 1.0](https://pytorch.org/). 
This extension will provide a simple way to create a DSVM and layer a new Python environment with fastai package, its dependencies and the course notebooks as part of the VM creation process. 

We provide these extensions in both Linux and Windows edition of the DSVM on Microsoft's Azure.  You can run the DSVM on either CPU or GPU instances though for model training, GPU instances will provide significant speed-up. We also provide templates to create either standard instances or the lower cost pre-emptable (also known as Low Priority) instances. 


Click one of the links below to deploy the desired Data Science VM instance with Fast AI extension. 

* [Linux Data Science VM with FastAI](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FDataScienceVM%2Fmaster%2FExtensions%2Ffastaiv1%2FazuredeployLinux.json)
* [Low cost Pre-emptable Linux Data Science VM with FastAI](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FDataScienceVM%2Fmaster%2FExtensions%2Ffastaiv1%2FazuredeployLinuxPreemptable.json)
* [Windows Data Science VM with Fast AI](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FDataScienceVM%2Fmaster%2FExtensions%2Ffastaiv1%2FazuredeployWindows.json)
* [Low cost Pre-emptable Windows Data Science VM with Fast AI](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FDataScienceVM%2Fmaster%2FExtensions%2Ffastaiv1%2FazuredeployWindowsPreemptable.json)

**NOTE**: You will need an Azure subscription. You can signup for a [free subscription](https://azure.microsoft.com/free) 
if you dont have one. You may not be able to create GPU instances with a free subscription. **Please stop the VM on the Azure portal when not in use to avoid being billed for usage**. 


You will be taken to the Azure Portal and in about 5-10 minutes your DSVM instance with the FastAI extension will be created where you can run the fast.ai course notebooks right away with literally no additional setup or configuration. On the Linux edition, you can signin to the built-in Jupyterhub using instructions [here](https://docs.microsoft.com/azure/machine-learning/data-science-virtual-machine/dsvm-ubuntu-intro#jupyterhub-and-jupyterlab) and access the notebooks. On the Windows edition, you can Remote desktop into the VM and then start Jupyter by clicking on the "Jupyter" icon on the taskbar. 


