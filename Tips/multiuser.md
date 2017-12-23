# Tips for using DSVM in multiuser configuration

This document will provide some guidances in using the DSVM in multiuser configurations. 

The tools on the DSVM (Anaconda Python, R, Julia etc) are in general installed in a common directory accessible by all users but usually writable by only the administrator or superuser. As such you can only install packages in default (global) directory only as an admin or ```su```. 

## Install Python packages only for one user
Python (through [PEP-370](https://www.python.org/dev/peps/pep-0370/)) has a concept of per user site-packages directory. You can use this feature to allow a non admin user to installa package they wish into their user directory while leveraging global packages that come preinstalled on the DSVM in the global anaconda directory. The base directory where the user specific package is installed  is ```~/.local``` for Linux and ```%APPDATA%\Python``` for Windows. 
Here is the command to do that. 

```
pip install <package-name> --user
```
If you are using distutils to install a package you can specify the ```--user``` argument like in ```pip``` above to install the packe to user specific directory.

NOTE: There does not seem to be a way to use this method with ```conda``` package manager. Please use ```pip``` if you want to install a package just for the user. 

This method applies to both Python 2.7 and Python 3.5. Just be sure you have activated the correct conda environment (root for Python 2.7 and py35 for Python 3.5 on the Data Science VM).

When you use a Python package that is installed in the user directory, you dont have to do anythign special since the search path for Python library is automatically set to use the user specific directory ahead of the global package directory. 

## Install R Packages only for one user
On the Data Science VM by default, the R packages are installed into the global R libraries directory. Only the root or Admin has the privileges to write to that directory and hence install new packages. This is fine since all users share the same R installation. However if a developer needs a  library just for their use and not affect other users, you can use the following method to install R packages only for the user. 

The steps are:

* Create a environment variable R_LIBS_USER in your .bashrc or user specific environment variable and point it to a directory under your home directory
* Create the directory
* Run ```install.packages("packagename")``` or better still ```install.packages("packagename",  lib=Sys.getenv("R_LIBS_USER"))```.

If you dont specify the lib parameter youmay get a warning if some other unwritable directory is ahead in the R ```.libPaths()``` (which specifies the search path that R uses to find the library to install or load). 

