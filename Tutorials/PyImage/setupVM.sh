#!/bin/bash

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

# install CNTK for ML Server's conda environment
#/data/mlserver/9.2.1/runtime/python/bin/pip install https://cntk.ai/PythonWheel/GPU/cntk-2.4-cp35-cp35m-linux_x86_64.whl
