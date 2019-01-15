#!/bin/bash
/anaconda/bin/conda create -y -n fastai python=3.6
source /anaconda/bin/activate fastai
/anaconda/bin/conda install  -y -c pytorch pytorch torchvision
/anaconda/bin/conda install  -y -c fastai fastai
/anaconda/bin/conda install  -y ipykernel
python -m ipykernel install --name 'fastai' --display-name 'Python (fastai)'
mkdir -p /etc/skel/notebooks/fastai
cd /etc/skel/notebooks/fastai
git clone https://github.com/fastai/course-v3
# copy the notebooks to the initial user's profile
for filename in /home/*; do
  dir=$filename/notebooks
  user=${filename:6}
  cp -r /etc/skel/notebooks/fastai $dir
  chown -R $user $dir/fastai/*
  chown $user $dir/fastai
done
