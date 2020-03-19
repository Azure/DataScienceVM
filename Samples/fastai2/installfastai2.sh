#!/bin/bash
apt install -y graphviz
sudo -i -u fastuser <<EOF
cd notebooks/
git clone https://github.com/fastai/fastbook.git
git clone https://github.com/fastai/course-v4.git
cd ..
git clone https://github.com/fastai/fastai2.git
cd fastai2
cat environment.yml
conda env create -f environment.yml
conda activate fastai2
pip install -r ../notebooks/fastbook/requirements.txt
EOF
