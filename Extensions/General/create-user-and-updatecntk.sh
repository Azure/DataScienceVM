#!/bin/bash

# Create N users. If no arg is specified 1 user is created. 
# Script also updates CNTK to RC2 and reinstalls tutorials
# This is for Ubuntu DSVM. Extensions run as root

if [ $# -eq 0 ]; then
        num=1
else
        num=$1
fi

# Download dataset for tutorial
cd /data
wget https://gksparkstore.blob.core.windows.net/gkaiimersion/Examples.tar.gz
tar xf Examples.tar.gz
rm Examples.tar.gz

source /anaconda/bin/activate py35
pip install --upgrade --no-deps https://cntk.ai/PythonWheel/GPU/cntk-2.0rc2-cp35-cp35m-linux_x86_64.whl
cd /etc/skel/notebooks
rm -rf CNTK
python -m cntk.sample_installer

cd /etc/skel/notebooks/CNTK-Samples-2-0rc2
mv Examples Examples2
ln -s /data/Examples Examples

# set up the CHAINER demo
docker pull chainer/chainer
mkdir /etc/skel/CHAINER
cd /etc/skel/CHAINER
wget https://raw.githubusercontent.com/Microsoft/AI-Immersion-Workshop/master/Deep%20Learning%20and%20the%20Microsoft%20Cognitive%20Toolkit/CNTK%20Hands-on%20in%20GPU%20DSVMs/download_MNIST_chainer.py
wget https://raw.githubusercontent.com/Microsoft/AI-Immersion-Workshop/master/Deep%20Learning%20and%20the%20Microsoft%20Cognitive%20Toolkit/CNTK%20Hands-on%20in%20GPU%20DSVMs/MNIST_chainer.py
# download the data for attendees
docker run -v /etc/skel/CHAINER:/host chainer/chainer /bin/bash -c "cd /host && python download_MNIST_chainer.py"

# start DIGITS in case they want to try it later
systemctl start digits

for i in $(seq 1 $num);  do
  u=`openssl rand -hex 2`;
  p=`openssl rand -hex 3`;
  useradd -m -d /home/user$u -s /bin/bash user$u
  echo user$u:A1imdl$p | chpasswd
  echo user$u, A1imdl$p >> '/data/usersinfo.csv';
  usermod -aG docker user$u
done

