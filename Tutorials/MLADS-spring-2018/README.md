# MLADS Tutorial

This tutorial was presented at MLADS (Machine Learning and Data Science), Microsoft's internal machine learning conference, in spring 2018. It is a hands-on tutorial on deep learning that focuses on image classification with CIFAR-10. It has three hands-on components:

1. Preprocessing images using the local Spark instance
2. Building an image classifier using the Microsoft Cognitive Toolkit
3. Deploying the model as a REST API using Microsoft ML Server

You can run this tutorial on your own Ubuntu DSVM by deploying the ARM template in the *setup* directory. Once your VM is created, log in to JupyterHub and navigate to the *MLADS-spring-2018* directory. The Jupyter notebooks are designed to be easy to follow along.

## Other components

The tutorial also included a demo of submitting the same code to Azure Batch AI to build a model using multiple VMs. The files to submit are in *CNTK_distributed*. This builds the same model as the Jupyter notebooks. It is designed to be run in a distributed manner.

You can also submit the Python file to the Ubuntu DSVM using VS Tools for AI.

