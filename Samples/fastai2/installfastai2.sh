#!/bin/bash
apt install -y graphviz
sudo -i -u fastuser <<EOF
cd notebooks/
git clone https://github.com/fastai/fastbook.git
git clone https://github.com/fastai/course-v4.git
conda create -y -n fastai2 python=3.7
conda activate fastai2
pip install -r fastbook/requirements.txt
pip install -Uqq fastbook
EOF
