#!/bin/bash

# Need to upgrade the SDK and install the widgets here

conda activate py36
conda install h5py

# tell Spark to use fewer resources so several users can submit simultaneous jobs
# sed -i -e 's/spark.driver.memory 5g/spark.driver.memory 1g/g' /dsvm/tools/spark/current/conf/spark-defaults.conf
# echo "spark.executor.cores 1" >> /dsvm/tools/spark/current/conf/spark-defaults.conf

# download the notebooks
mkdir /etc/skel/notebooks/MLADS-fall-2018
git clone https://github.com/Azure/DataScienceVM /data/DataScienceVM
mv /data/DataScienceVM/Tutorials/MLADS-fall-2018/* /etc/skel/notebooks/MLADS-fall-2018

# copy the notebooks to the initial user's profile
for filename in /home/*; do
  dir=$filename/notebooks
  user=${filename:6}
  cp -r /etc/skel/notebooks/MLADS-fall-2018 $dir
  chown -R $user $dir/MLADS-fall-2018/*
  chown $user $dir/MLADS-fall-2018
done

# create users
# we are skipping this part now that MLADS is over, and most people using this template want
# to use it with the initial user account
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
