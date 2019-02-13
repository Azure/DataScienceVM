cmd.exe /c "activate root &  conda create -y -n fastai python=3.6.5 ipykernel nbconvert scipy"
cmd.exe /c "activate fastai &  conda install -c pytorch pytorch=1.0.0  -y"
cmd.exe /c "activate fastai &  pip install fastai"
function fixKernelSpec()  ##Fix the kernels name in course notebook to ensure right kernel is started
{

  [cmdletbinding()]

  Param (

  [parameter(ValueFromPipeline)]

  [string]$file

  )


$regex_to_match_kernelspec = '"kernelspec": {[a-zA-Z 0-9\r\n\"_:\[\],\(\)\.]*}'
$replacement_kernelspec = '"kernelspec": { "display_name": "Python [conda env:fastai]",   "language": "python",  "name": "conda-env-fastai-py"  }'

$t=Get-Content -Raw -Path $file 
$t -Replace $regex_to_match_kernelspec , $replacement_kernelspec | Out-File $file -Encoding ASCII 
}

New-Item -ItemType Directory -Force -Path "C:\dsvm\notebooks\fastai"
Set-Location "C:\dsvm\notebooks\fastai"
git clone https://github.com/fastai/course-v3
Get-ChildItem -Path *.ipynb -Recurse -Force| foreach  { $_.FullName |  fixKernelSpec  }
# Set default browser for Jupyter to Firefox
@"
import webbrowser
webbrowser.register('firefox', None, webbrowser.GenericBrowser('C:\\Program Files\\Mozilla Firefox\\firefox.exe'))
c.NotebookApp.browser = 'firefox'
"@ | out-file -Append C:\ProgramData\jupyter\jupyter_notebook_config.py -enc ascii

