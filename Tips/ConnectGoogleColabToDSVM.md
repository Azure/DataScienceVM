# Using Data Science VM as a backend runtime compute for Google Colab

Google Research's [Collaboratory](https://colab.research.google.com/) or known as **Colab** is a free Jupyter environment in the Cloud. 
In addition to provide a cloud based runtime, it provides mechanism to use your computer or any virtual machine (VM) in the cloud as a runtime to execute your notebooks. 
The benefits of doing this especially with a cloud based VM is having a more powerful runtime to execute your experiments on Colab while retaining some of the frontend features of Colab like saving notebooks on Google drive and sharing. 
The added benefit of using a [Data Science VM on Azure](http://aka.ms/dsvm) (DSVM) is that you have access to a plethora of built-in tools for data science, machine learning and deep learning including ability to execute on powerful GPU based VM instances on Azure. 


It is pretty straight forward to point your Colab runtime at a Ubuntu based DSVM on Azure. The [documentation to setup local runtime](https://research.google.com/colaboratory/local-runtimes.html) 
on Colab website works quite nicely for Azure VMs like DSVM. We provide the exact steps specifically for the DSVM for better clarity and convenience of users of the DSVM. 

## Steps to setup DSVM as a Colab runtime

0. Prerequisites: You already have a Ubuntu based DSVM instance on Azure. If you dont have one (but have an Azure subscription), you can create a DSVM instance on the 
[Azure Portal](https://portal.azure.com/#create/microsoft-dsvm.linux-data-science-vm-ubuntulinuxdsvmubuntu) and then following the wizrd by clicking "Create".  [Free trials](http://azure.com/free) are available if you dont have an Azure subscription. 

1. Setup an SSH tunnel from your desktop to the DSVM and login to your DSVM. 

```
ssh -L 9999:localhost:9999 YOURUSERONDSVM@YourDSVMFullDNSNameOrIP
```
Enter the password to your DSVM when prompted. You can authenticate using SSH keys if you have set one up. 

**Note**: SSH client is now enabled by default on Windows 10 as of April 2018 Update. 

2. Once you are on the DSVM shell, run the following commands as a one time setup. 

```
sudo -i pip install jupyter_http_over_ws
jupyter serverextension enable --py jupyter_http_over_ws
```
3. Start the Jupyter notebook on the DSVM

```
jupyter notebook   --NotebookApp.allow_origin='https://colab.research.google.com'   --port=9999 --no-browser --NotebookApp.ip='*'  
```
The port that you use for Jupyter must be the same destination port tunnelled in Step 1. 

4. Now visit Colab. For example you can visit this basic [Tensorflow on GPU sample](https://colab.research.google.com/notebooks/gpu.ipynb). Change runtime to "Python 3" since we have Tensorflow installed only in Python 3 environment on DSVM.

5. Click the "Connect to local runtime" link on the top right in Colab. When it prompts for the backend port, enter the local port on your desktop (from where you are browsing to Colab) which is tunnelled to the Jupyter port on the DSVM on Azure. This would be port 9999 is you used the command the values as above. Within a second or so, your Colab notebook is connected to the Jupyter server on the DSVM as the backend. If the DSVM is running on a GPU based Azure VM instance you will be able to leverage the GPU for training your deep learning models. 

That is it! 

It is quite simple if you just follow the above instructions. 
Now you can combine the benefit of Colab and Azure Data Science VM for a more productive environment with a dedicated powerful infrastructure with a host of preconfigured tools to train your deep learning / machine learning models and for data science in general. 

## Known Issues
1. We could not find a clean way to terminate the remote notebook (and release resources) on the DSVM from Colab as there is no "Close and Halt" menu option you see in Jupyter UI on Colab. 
With notebooks that use the GPU, the memory was not released and further programs could not be started. A crude (and highly questionable) workaround to release GPU memory was to run "exit()" in the last cell of the notebook (The notebook kernel itself may try to restart). Are there any better ways to terminate the remote notebook kernel?




