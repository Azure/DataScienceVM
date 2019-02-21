# Joining Ubuntu DSVM to Active Directory

This document shows how you can  join a Ubuntu DSVM to your active directory domain. 

Assumption: Your DSVM is connected to your VNet that hosts the corporate or Azure active directory

Reference: https://help.ubuntu.com/community/ActiveDirectoryWinbindHowto

Here are the steps to this process. 

1. Login to your VM with the local credentials created during creation. This account will have sudo permissions
2. Run the following commands: 

<pre>
sudo apt-get install winbind samba libnss-winbind libpam-winbind
cat << EOF | sudo tee /etc/samba/smb.conf > /dev/null
[global]
        security = ads
        realm = YOURACTIVEDIRECTORYFULLDOMAININCAPS (for example: LAB.EXAMPLE.COM)
# If the system doesn't find the domain controller automatically, you may need the following line
#        password server = 10.0.0.1
# note that workgroup is the 'short' domain name
        workgroup = YOURSHORTDOMAIN (for example: LAB)
#       winbind separator = +
        idmap uid = 10000-20000
        idmap gid = 10000-20000
        winbind enum users = yes
        winbind enum groups = yes
        template homedir = /home/%U
        template shell = /bin/bash
        client use spnego = yes
        client ntlmv2 auth = yes
        encrypt passwords = yes
        winbind use default domain = yes
        restrict anonymous = 2
EOF

</pre>

3. Manually edit the file /etc/nsswitch.conf and add winbind to the "passwd:" and "group:" line. It should look like this.

        passwd:         compat winbind
        group:          compat winbind

4. Run the following commands
<pre>
sudo /etc/init.d/winbind stop
sudo /etc/init.d/samba restart
sudo /etc/init.d/winbind start
sudo net ads join -U domainusername
#Enter password when prompted
sudo pam-auth-update
# Enable create home directory option. 
</pre>

That is it. Your DSVM is now joined to active directory and your  users can login with their corp credentials. You can also login to JupyterHub using the Active directory credentials.  


