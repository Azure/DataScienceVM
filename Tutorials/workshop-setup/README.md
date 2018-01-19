# Data Science and AI Workshops
The DSVM team has run several large training workshops (>100 attendees) for data scientists and AI developers. Rather than asking users to install software on their laptops, we gave each attendee a login to an [Ubuntu DSVM](http://aka.ms/dsvm/ubuntu) with all training material and datasets pre-loaded and configured. All content was provided as Jupyter notebooks, and attendees were able to run the notebooks through JupyterHub. Attendees needed only a laptop and a web browser to access the training material. We found this approach to be simple to follow for attendees. It ensured that everyone used the same set of tools and gave everyone the opportunity to run code on a high-performance GPU. The workshops were extremely successful and had a very high rate of completion. Here we share details of setting up a workshop and some common pitfalls to avoid. See our [blog post](https://blogs.technet.microsoft.com/machinelearning/2018/01/10/running-large-scale-educational-workshops-in-deep-learning-data-science/) for additional information.

# Workshop Setup

To set up a workshop:

1. Prepare the training material and datasets on a single [Ubuntu DSVM](http://aka.ms/dsvm/ubuntu). Code should be Jupyter notebooks, as attendees will log in to the VMs through JupyterHub. JupyterHub also provides a terminal through the browser (choose New -> Terminal in the top-right corner). This can be used to run docker, nvidia-smi, and other tools.

2. Put the material in a location that it can be transferred to the attendee VMs. We recommend putting everything in a single tar.gz file, uploading it to a container in blob storage, and generating a URL for the file. If you want to keep the container private, you can generate a SAS URL.

3. Create a script to run on each attendee VM to set up the training material and create usernames and passwords. See [this example](https://github.com/Azure/DataScienceVM/blob/master/Extensions/General/create-user-and-updatecntk.sh) which downloads data, installs pip packages, starts the DIGITS service, and performs other setup tasks. Any content that you want to be available for each user should be placed in /etc/skel, and any notebooks should go in /etc/skel/notebooks. Put this script in blob storage so it is available to run on each VM. Datasets should go in /data. Avoid putting material in /tmp, as that location is cleared when the VM is rebooted. Also avoid using /mnt, as that location is host-local storage and may be cleared if the VM migrates to a new host.

4. Create a single attendee VM for testing. Use the [multi-VM ARM template with extension](https://github.com/Azure/DataScienceVM/blob/master/Scripts/CreateDSVM/Ubuntu/multiazuredeploywithext.json) and specify one VM and your setup script. We recommend ~5 attendees share a VM for deep learning code, though your mileage will vary considerably depending on the code attendees will run. We also recommend that you use NC6 or NC6v2 series with a single GPU. Using more than one GPU may result in throughput bottlenecks.

5. Log in to JupyterHub on the VM using one of the user accounts. Your training material should be available in the notebooks. Test it well. This is the same experience your users will have.

6. Log in to JupyterHub on the VM using a second user (say, by using another browser or an incognito window) and try running the code while simultaneously running it with the first user. This will eliminate any issues with multiple users running the code in parallel. See the Memory Usage section below for common issues regarding GPU memory. The Microsoft Cognitive Toolkit will lock the GPU for exclusive access, preventing multiple users from using it, unless you edit your code as described in [this GitHub issue](https://github.com/Microsoft/CNTK/issues/1592) and [the documentation](https://docs.microsoft.com/en-us/python/api/cntk.device?view=cntk-py-2.3).

7. Use the same [multi-VM ARM template with extension](https://github.com/Azure/DataScienceVM/blob/master/Scripts/CreateDSVM/Ubuntu/multiazuredeploywithext.json) to create all VMs for the workshop. You can create the VMs ahead of time, then stop them until they're needed. The Azure CLI makes it easy to automate starting and stopping many VMs.

# Memory Usage in Deep Learning Workshops

It is easy to run out of GPU memory when multiple users are using the same GPU. You can use the *nvidia-smi* command to determine how much GPU memory a single example uses and how much total GPU memory is available; this will tell you how many users can run the example in parallel. You can reduce memory usage by reducing the batch size or reducing the size of the network (e.g., by removing layers).

Once a Jupyter notebook is run, it will retain GPU memory until it is fully closed. If attendees will be running several notebooks, it is possible that the cumulative memory usage of all attendees on a VM across all running notebooks will exceed the GPU's total memory. The easiest way to avoid this is to have attendees completely close each notebook by choosing *File* -> *Close and Halt* when they're finished with it.

TensorFlow will allocate all GPU memory for a single session by default. You can limit this in your code. Here we limit a session to 10% of the total GPU memory, so ten attendees could simultaneously run an example.

    gpu_options = tf.GPUOptions(per_process_gpu_memory_fraction=0.1)
    sess = tf.Session(config=tf.ConfigProto(gpu_options=gpu_options))
