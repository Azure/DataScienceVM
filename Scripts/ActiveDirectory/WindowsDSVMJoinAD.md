# Joining Windows DSVM to Active Directory

This document shows how you can  join a Windows DSVM to your active directory domain. 

Assumption: Your DSVM is connected to your VNet that hosts the corporate or Azure active directory

Once your DSVM is created and in the your corp network VNET with access your active directory do the following:

1. Login to the DSVM with the credentials used during the creation. 
2. Run the following in a command prompt run as administrator. 

<pre>
# Open cmd window as administrator

# Disable UAC
REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0x0 /f

# Run the command after replacing <UserName> with your alias and <Password> with your password
netdom join %COMPUTERNAME% /domain:{FULLY QUALIFIED DOMAIN}/userd:{DOMAIN}\{USERNAME} /passwordd:{PASSWORD}

# Run the following code to add the team as Windows admin
net localgroup administrators {DOMAIN}\{USERNAME} /add

# Run the following code to add account as SQL admin for the local SQL Server database on the DSVM (if needed)
sqlcmd -Q "sp_addsrvrolemember '{DOMAIN}\{USERNAME}', 'sysadmin'"

# Run Windows Update 

# Restart your machine 
</pre>

That is it. Your DSVM is now joined to active directory and your  users can login with their corp credentials. They will have access to corp resources like file share, onprem databases depending on the permission for the domain user. 
