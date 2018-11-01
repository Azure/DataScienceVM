# Mounting Azure Storage on Linux DSVM

## Mounting Azure Files 

```
#!/bin/bash
# $1 = Azure storage account name
# $2 = Azure storage account key
# $3 = Azure file share name
# $4 = mountpoint path

# For more details refer to https://azure.microsoft.com/en-us/documentation/articles/storage-how-to-use-files-linux/

mkdir -p $4
mount -t cifs //$1.file.core.windows.net/$3 $4 -o vers=3.0,username=$1,password=$2,dir_mode=0777,file_mode=0777
```

## Mounting Azure Blob using BlobFuse

Blobfuse is a userr mode file system that allows you to mount  Azure Blob containers on Linux machines as a regular file system mount.  Blobfuse is already preinstalled on the Ubuntu DSVM. 

You will need your storage account name, storage account access key and container name. For best performance, a fast local disk (like the scratch disk on Azure VM mounted on /mnt is used for temprary local cache for blobfuse). 


The steps to mount a blob are:

```
# Create temp directory on the local SSD mounted on /mnt. 
# By default regular users cannot write. So we need to use sudo here and change ownership
# ONE TIME SETUP
sudo mkdir -p /mnt/blobfusetmp
sudo chown <<Your user name>> /mnt/blobfusetmp
sudo mkdir -p /mnt/blobfusemount
sudo chown <<Your user name>> /mnt/blobfusemount
# To mount run each time
# For details on blobfuse : https://github.com/Azure/azure-storage-fuse
AZURE_STORAGE_ACCOUNT=<<Storage Account Name>>;AZURE_STORAGE_ACCESS_KEY=<<Storage Account Key>>;blobfuse /mnt/blobfusemount --container-name=<<Container Name in Storage Account Blob>> --tmp-path=/mnt/blobfusetmp
```
You can also create (and secure) a config file (say /path/to/connection.cfg) with the storage account name and key and use the --config-file=/path/to/connection.cfg. You can also use Azure Storage SAS Key instead of access key by setting the AZURE_STORAGE_SAS_TOKEN environment variable instead of AZURE_STORAGE_ACCESS_KEY.
