#!/bin/bash

/anaconda/envs/py36/bin/pip freeze | grep azureml- | xargs /anaconda/envs/py36/bin/pip uninstall -y
/anaconda/envs/py36/bin/pip install --upgrade azureml-sdk[notebooks,automl,contrib,explain]

az extension remove -n azure-cli-ml
az extension add -s https://azuremlsdktestpypi.blob.core.windows.net/wheels/sdk-release/Preview/E7501C02541B433786111FE8E140CAA1/azure_cli_ml-0.1.50-py2.py3-none-any.whl --pip-extra-index-urls https://azuremlsdktestpypi.blob.core.windows.net/wheels/sdk-release/Preview/E7501C02541B433786111FE8E140CAA1 -y

cat << EOF > /opt/set_notebook_kernel_for_azureml.py
#!/usr/bin/python
import json,sys
if len(sys.argv) < 2 :
        print "Usage: python set_notebook_kernel_for_azureml.py <filename>"
        exit()
with open(sys.argv[1], "r") as jsonFile:
    data = json.load(jsonFile)
data["metadata"]["kernelspec"]["display_name"] = "Python 3.6 - AzureML"
data["metadata"]["kernelspec"]["name"] = "python3-azureml"
with open(sys.argv[1], "w") as jsonFile:
    json.dump(data, jsonFile)
EOF

pushd /etc/skel/notebooks/AzureML
git stash
git pull
find . -name \*.ipynb -exec /usr/bin/python /opt/set_notebook_kernel_for_azureml.py {} \;
popd

for filename in /home/*; do
  dir=$filename/notebooks/AzureML
  user=${filename:6}
  rm -rf $dir
  cp -r /etc/skel/notebooks/AzureML $dir
  chown -R $user $dir
  chgrp -R $user $dir
done

host=`hostname`
# create users
for i in $(seq 1 6);  do
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
  echo $host, user$u, $p >> '/data/usersinfo.csv';
  usermod -aG docker user$u
done