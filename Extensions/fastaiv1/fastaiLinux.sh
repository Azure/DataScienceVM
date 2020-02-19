#!/bin/bash
/anaconda/bin/conda create -y -n fastai python=3.6
source /anaconda/bin/activate fastai
pip install dataclasses
/anaconda/bin/conda install  -y -c pytorch pytorch torchvision cudatoolkit=10.1
/anaconda/bin/conda install  -y -c fastai fastai pillow=6.2.1
/anaconda/bin/conda install  -y ipykernel nbconvert ipywidgets
python -m ipykernel install --name 'fastai' --display-name 'Python (fastai)'
# Script to update Notbook metadata
cat << EOF > /tmp/changenbmeta.py
#!/usr/bin/python
import json,sys

if len(sys.argv) < 2 :
        print "Usage: python changenbmeta.py <filename>"
        exit()
with open(sys.argv[1], "r") as jsonFile:
    data = json.load(jsonFile)

data["metadata"]["kernelspec"]["display_name"] = "Python (fastai)"
data["metadata"]["kernelspec"]["name"] = "fastai"

with open(sys.argv[1], "w") as jsonFile:
    json.dump(data, jsonFile)

EOF

mkdir -p /etc/skel/notebooks/fastai
cd /etc/skel/notebooks/fastai
git clone https://github.com/fastai/course-v3

# Change metadata on notebook to match kernel name in the fast.ai notebooks
find . -name \*.ipynb -exec /usr/bin/python /tmp/changenbmeta.py {} \;

# copy the notebooks to the initial user's profile
for filename in /home/*; do
  dir=$filename/notebooks
  user=${filename:6}
  cp -r /etc/skel/notebooks/fastai $dir
  chown -R $user $dir/fastai/*
  chown $user $dir/fastai
done
