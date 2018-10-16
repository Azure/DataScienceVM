# Running Batch jobs on Batch AI 
In machine learning and data science, there are many common scenarios where you have to run programs or scripts in a batch.  Some examples of batch executions are recurring data pre-processing, model retraining, batch scoring. 
Here is a way you can develop your code on a [Data Science Virtual Machine (DSVM)](http://aka.ms/dsvmdoc) and setup batch execution using the [Azure Batch AI service](https://docs.microsoft.com/azure/batch-ai/) where the execution happens on a similar DSVM environment
that you used for development. In this walkthrough, we go through steps to execute an R program as a very basic batch execution on Azure Batch AI service. 

The steps to do this are as follows:


1. Develop and test your code (in R, Python, Julia, C# etc) in the normal way on the DSVM using the rich prebuilt tools and frameworks. This code typically takes a data file that is used to process as a batch. 

2. Create a BatchAI workspace using Azure CLI after logging into your Azure account. Note: Parameters values for resource names below are placeholders. You need to choose names for your application. 

```
az group create --name dsvmbatch --location westus2
az batchai workspace create -g dsvmbatch -n dsvmbatchai
```

3. Create a cluster of machines used to run jobs in the Batch AI service. You can specify a suitable size of Azure VM instance. 
```
az batchai cluster create -n cpucluster -g dsvmbatch  -w dsvmbatchai -s Standard_D2_v2  -i UbuntuDSVM -t 1 --generate-ssh-keys
```

4. Create a BatchAI experiment

```
az batchai experiment create -n bcdetect -g dsvmbatch  -w dsvmbatchai
```

4. Create a job run configuration. For running an R script, here is a boiler plate. In this example, we run an R sample script  prepackaged on the DSVM. The logs and output are written to an Azure Files mounted on the Batch AI nodes. 
```
{
    "$schema": "https://raw.githubusercontent.com/Azure/BatchAI/master/schemas/2018-05-01/custom.json",
    "properties": {
        "nodeCount": 1,
        "customToolkitSettings": {
            "commandLine": "Rscript /dsvm/samples/Microsoft_ML_Server/R/101/BinaryClassification/BreastCancerPrediction/BreastCancerPrediction.R"
        },
        "stdOutErrPathPrefix": "$AZ_BATCHAI_JOB_MOUNT_ROOT/logs",
        "mountVolumes": {
            "azureFileShares": [
                {
                    "azureFileUrl": "https://[[YOUR STORAGE ACCOUNT]].file.core.windows.net/logs",
                    "relativeMountPath": "logs"
                }
            ]
        }
    }
}
```

5. Create a Batch AI job and use the configuration above
```
az batchai job create -n rjob -c cpucluster -g dsvmbatch -w dsvmbatchai -e bcdetect -f batchaiRjob.json --storage-account-name dsvmworkshop
```

6. Monitor the job state and download results
```
az batchai job show -n rjob2 -g dsvmbatch -w dsvmbatchai -e bcdetect

# Download the standard out file after successful run
az batchai job file stream -j rjob -g dsvmbatch -w dsvmbatchai -e bcdetect -f stdout.txt
```

7. (Optional) Scale down cluster if you are not running jobs immediately
```
az batchai cluster resize  -n cpucluster -g dsvmbatch  -w dsvmbatchai    -t 0
```
This tip just demonstrates a very basic usage of Batch AI to help get started easily. We used the CLI for managing the batch. However you can use the SDK in Python, node.js, .Net or access through REST API in language of your choice. There are other features of Batch AI like auto scaling, low priority nodes (which cost significantly lesser than dedicated nodes). 
More information  can be found on the [Azure Batch AI service](https://docs.microsoft.com/azure/batch-ai/) documentation page. 

A lower level infrastructure service on Azure to execute batch jobs is the [Azure Batch service](https://docs.microsoft.com/azure/batch/). The DSVM image can be used a base for the Azure Batch service processing nodes. A basic walkthrough of running batch jobs on Azure Batch can be found in a related [tip](Tips/DSVMWithAzureBatch.md). 



