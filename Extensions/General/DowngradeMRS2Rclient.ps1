# Uninstall Microsoft R Server first
(Get-WmiObject -Class win32_product  -Filter "Name like 'Microsoft R Server%'").Uninstall()

# Download R Client
cmd /c "curl -L http://aka.ms/rclient -o \tmp\RClientSetup.exe"

# Install R Client
cmd /c "c:\tmp\RClientSetup.exe /quiet"

# Disable SQL Launchpad
set-Service -name "MSSQLLaunchpad" -StartupType Disabled
Stop-Service -name "MSSQLLaunchpad"

# Cleanup
del C:\tmp\RClientSetup.exe
