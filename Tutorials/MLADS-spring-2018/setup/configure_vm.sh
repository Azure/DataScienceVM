#!/bin/bash

# tell Spark to use fewer resources so several users can submit simultaneous jobs
sed -i -e 's/spark.driver.memory 5g/spark.driver.memory 1g/g' /dsvm/tools/spark/current/conf/spark-defaults.conf
echo "spark.executor.cores 1" >> /dsvm/tools/spark/current/conf/spark-defaults.conf

# configure MLS
cd /opt/microsoft/mlserver/9.2.1/o16n
sudo dotnet Microsoft.MLServer.Utils.AdminUtil/Microsoft.MLServer.Utils.AdminUtil.dll -silentoneboxinstall Dsvm@123

# download the CIFAR-10 dataset
wget -O /data/cifar-10-python.tar.gz http://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz

# download the notebooks
mkdir /etc/skel/notebooks/MLADS-spring-2018
git clone https://github.com/Azure/DataScienceVM /data/DataScienceVM
mv /data/DataScienceVM/Tutorials/MLADS-spring-2018/* /etc/skel/notebooks/MLADS-spring-2018

# update to the 390.46 driver
wget -O nvidia-diag-driver-local-repo-ubuntu1604-390.46_1.0-1_amd64.deb "https://dsvmbuildmaster.blob.core.windows.net/linux/nvidia-diag-driver-local-repo-ubuntu1604-390.46_1.0-1_amd64.deb?st=2018-05-22T17%3A19%3A00Z&se=2018-06-24T17%3A19%3A00Z&sp=rl&sv=2017-07-29&sr=b&sig=0pqP%2FGhVoOUGh5cZQXx7HxvjH4NZO3OBwX69bAElUQU%3D"
dpkg -i nvidia-diag-driver-local-repo-ubuntu1604-390.46_1.0-1_amd64.deb
apt-get update
apt-get install cuda-drivers=390.46-1 -y

# create users
for i in $(seq 1 4);  do
  u=`openssl rand -hex 2`;
  # replace 1 with g
  u=`echo $u | sed -e 's/1/g/g'`
  # replace 0 with h
  u=`echo $u | sed -e 's/0/h/g'`

  p=`openssl rand -hex 4`;
  # replace 1 with g
  p=`echo $p | sed -e 's/1/g/g'`
  # replace 0 with h
  p=`echo $p | sed -e 's/0/h/g'`

  useradd -m -d /home/user$u -s /bin/bash user$u
  echo user$u:$p | chpasswd
  echo user$u, $p >> '/data/usersinfo.csv';
  usermod -aG docker user$u
done

# install CNTK for ML Server's conda environment
/data/mlserver/9.2.1/runtime/python/bin/pip install https://cntk.ai/PythonWheel/GPU/cntk-2.4-cp35-cp35m-linux_x86_64.whl
