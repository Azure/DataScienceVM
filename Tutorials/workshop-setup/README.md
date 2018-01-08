# Data Science and AI Workshops

The DSVM team has run several large training workshops for data scientists and AI developers. Rather than asking users to install software on their laptops, we gave each attendee a login to an Ubuntu DSVM with all software and datasets loaded and configured. Attendees needed only a web browser to access the training material. We found this approach .... .

# Workshop Setup

To set up a workshop:

1. Prepare the training material and datasets on a single Ubuntu DSVM. Code should be Jupyter notebooks, as attendees will log in to the VMs through JupyterHub. JupyterHub also provides a terminal through the browser. This can be used to run Docker, nvidia-smi, and other tools.

2. Put the material in a location that it can be transferred to the attendee VMs. We recommend putting everything into a single tar.gz file, uploading it to blob storage in a container, and generating a URL for the file. If you want to keep the container private, you can generate a SAS URL.

3. Create a script to run on each attendee VM to set up the training material and create usernames and passwords. See [this example](https://github.com/Azure/DataScienceVM/blob/master/Extensions/General/create-user-and-updatecntk.sh) which downloads data, installs pip packages, starts the DIGITS service, and performs other setup tasks. Any content that you want to be available for each user should be placed in /etc/skel, and any notebooks should go in /etc/skel/notebooks. Put this script in blob storage so it is available to run on each VM.

4. Create a single attendee VM for testing. Use the [multi-VM ARM template with extension](https://github.com/Azure/DataScienceVM/blob/master/Scripts/CreateDSVM/Ubuntu/multiazuredeploywithext.json) and specify one VM and your setup script.

5. Log in to JupyterHub on the VM using one of the user accounts. Your training material should be available in the notebooks. Test it well. This is the same experience your users will have.

6. Log in to JupyterHub on the VM using a second user (say, by using another browser or an incognito window) and try running the code while simultaneously running it with the first user. This will eliminate any issues 

TF aggressive memory 
CNTK global lock
close and halt for each notebook