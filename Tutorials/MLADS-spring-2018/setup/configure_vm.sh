#!/bin/bash

# tell Spark to use fewer resources so several users can submit simultaneous jobs
sed -i -e 's/spark.driver.memory 5g/spark.driver.memory 1g/g' /dsvm/tools/spark/current/conf/spark-defaults.conf
"spark.executor.cores 1" >> /dsvm/tools/spark/current/conf/spark-defaults.conf

# configure MLS
cd /opt/microsoft/mlserver/9.2.1/o16n
sudo dotnet Microsoft.MLServer.Utils.AdminUtil/Microsoft.MLServer.Utils.AdminUtil.dll -silentoneboxinstall Dsvm@123

# download the CIFAR-10 dataset
wget -O /data/cifar-10-python.tar.gz http://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz

# download the notebooks
mkdir /etc/skel/notebooks/MLADS-spring-2018
git clone https://github.com/Azure/DataScienceVM /data/DataScienceVM
mv /data/DataScienceVM/Tutorials/MLADS-spring-2018/* /etc/skel/notebooks/MLADS-spring-2018
