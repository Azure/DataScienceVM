# Uninstall Microsoft R Server first
(Get-WmiObject -Class win32_product  -Filter "Name like 'Microsoft R Server%'").Uninstall()

# Download R Client
cmd /c "curl -L http://aka.ms/rclient -o \tmp\RClientSetup.exe"

# Install R Client
cmd /c "c:\tmp\RClientSetup.exe /quiet"

# Disable SQL Launchpad
set-Service -name "MSSQLLaunchpad" -StartupType Disabled
Stop-Service -name "MSSQLLaunchpad"

# Set Machine path with R client
$path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + "C:\Program Files\Microsoft\R Client\R_SERVER\bin\x64"
[environment]::SetEnvironmentVariable("path", "$path","machine")
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

# Install some R libraries and Jupyter R Kernel. You can add  other libraries you want to install to the list below.
cmd /c rscript.exe -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest', 'dplyr', 'ggplot2', 'AzureML', 'xgboost', 'stringi', 'stringr', 'tidyr'))"
cmd /c rscript.exe -e "devtools::install_github('IRkernel/IRkernel')"

# Cleanup
del C:\tmp\RClientSetup.exe
