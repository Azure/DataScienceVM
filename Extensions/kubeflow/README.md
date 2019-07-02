# Extension for the Kubeflow on Azure Data Science Virtual Machine

This is an extension to the [Microsoft Azure Data Science Virtual Machine (DSVM)](http://aka.ms/dsvm) to enable creation of a one node [Kubernetes](https://kubernetes.io/) instance based on [microk8s](https://microk8s.io/) with [Kubeflow](https://www.kubeflow.org/) machine learning toolkit. This extension will provide a simple way to create a DSVM and automatically install a one node Kubeflow as part of the VM creation process. The one node install is suitable for learning and development purposes only as it lacks redundancy and production level security (like role based access control). When you are ready to scale up or run production workload with Kubeflow, you can run it on a production cluster or a managed cloud based [Azure Kubernetes service (AKS) production cluster](https://www.kubeflow.org/docs/azure/).  

You can use the DSVM with Kubeflow on either CPU or GPU instances though for model training, GPU instances will provide significant speed-up. 


[Deploy Linux Data Science VM with Kubeflow](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FDataScienceVM%2Fmaster%2FExtensions%2Fkubeflow%2FazuredeployLinux.json)


**NOTE**: You will need an Azure subscription. You can signup for a [free subscription](https://azure.microsoft.com/free) 
if you dont have one. You may not be able to create GPU instances with a free subscription. **Please stop the VM on the Azure portal when not in use to avoid being billed for usage**. 