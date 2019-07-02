#!/bin/bash
mkdir -p /data/snap
mkdir -p /data/snap/microk8s
ln -s /data/snap/microk8s /var/snap/microk8s 

. /etc/profile

export HOME=${HOME:-'/root'}
cd $HOME
git clone https://github.com/canonical-labs/kubernetes-tools
kubernetes-tools/setup-microk8s.sh

# Crude check for presence of GPU
numgpu=`lspci | grep -i nvidia | wc -l`
if [ $numgpu -ne 0 ]; then
  microk8s.enable gpu
fi

git clone https://github.com/canonical-labs/kubeflow-tools
kubeflow-tools/install-kubeflow.sh

