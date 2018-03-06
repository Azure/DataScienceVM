# Working with Azure Databricks from the Data Science VM

This article discusses how you can develop your Spark (PySpark, Scala) code on the Data Science Virtual Machine and deploy them on Azure  Databricks for scaling out. 
The Windows 2016 DSVM (Mar 2018 edition onwards) comes pre-loaded with Databricks CLI that is used throughout in this article. We will be adding the CLI to other editions soon. 

Hence is a high level steps and commands:

1. Activate to the correct Python environment

Databricks CLI is supported currently only in Python 2.7. On the data science VM, the python 2.7 conda environment is ```python2```.

```
activate python2
```

2. Associate your CLI to your Azure Databricks account
```
databricks configure --token
```

This will prompt you to enter the token. You have to generate the token on your Databrocks workspace as specified in the [documentation](https://docs.azuredatabricks.net/api/latest/authentication.html#token-management).

3. Now you can create folders on Databricks workspace
```
databricks workspace mkdirs /dsvmtest
```

4. Develop you Spark programs including notebooks on the Data Science VM. Test it locally on the standalone Spark on the Data Science VM. 

5. Upload the Python or Scala or Notebook  file to the Databricks workspace
```
databricks workspace import "sample1.ipynb" /dsvmtest/sample1 -l PYTHON -f JUPYTER
```

6. Next you can create a cluster on Databricks that will serve as the compute.
```
#Create a cluster on the portal and run the notebook. 
# You can also create through CLI "databricks clusters create --json-file <cluster spec file>"

# Now try to deploy the notebook as a Job. 
```
7. Submit a Job
```
databricks jobs create --json-file <JOB SPEC FILE>
```

The Job Spec file looks like this:
```
dbjobspec.txt
{
	"name":"MMLspark submit python job",	
      "existing_cluster_id": "0222-234567-cloud137",
    "notebook_task": {
      "notebook_path": "/dsvmtest/sample1"
    }
}
```

Note: You can also upload Python scripts/ notebooks to DBFS and reference notebook_path as dbfs:/xxx.ipynb or dbfs://yyy.py 

8. Check the status of the Job
```
databricks runs list
databricks runs get --run-id <runID>
```

We have shown how easy is it to develop and debug your Spark applications on the Data Science VM on the standalone instance and then scale it out on the Databricks Spark cluster for performance and manageability. 


