### Determine version of your Data Science VM Instance

Azure has a nifty metadata service that can provide information about your Data Science VM including version of the image you are running. You need to run the following on the DSVM for which you want to get the metadata information. 

On commmand prompt on Windows OR Bash on Linux DSVM run:
```
curl -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | python -m json.tool
```

Note: The python code snippet above is to just pretty print the JSON out from Azure metadata service. 

The output will look like:

```
{
    "compute": {
        "location": "eastus",
        "name": "xxxxxxxx",
        "offer": "linux-data-science-vm-ubuntu",
        "osType": "Linux",
        "placementGroupId": "",
        "platformFaultDomain": "0",
        "platformUpdateDomain": "0",
        "publisher": "microsoft-ads",
        "resourceGroupName": "xxxxxxxxxxx",
        "sku": "linuxdsvmubuntu",
        "subscriptionId": "XXXXXXXXXXXXXXXXXXXXXXXX",
        "tags": "Application:DataScience",
        "version": "1.1.6",
        "vmId": "XXXXXXXXXXXXXXXXXXX",
        "vmSize": "Standard_DS2_v2"
    },
    "network": {
        "interface": [
            {
                "ipv4": {
                    "ipAddress": [
                        {
                            "privateIpAddress": "10.0.0.XX",
                            "publicIpAddress": "XX.YY.ZZ.AA"
                        }
                    ],
                    "subnet": [
                        {
                            "address": "10.0.0.0",
                            "prefix": "24"
                        }
                    ]
                },
                "ipv6": {
                    "ipAddress": []
                },
                "macAddress": "XXXXXX"
            }
        ]
    }
}
```

Very nifty indeed!
