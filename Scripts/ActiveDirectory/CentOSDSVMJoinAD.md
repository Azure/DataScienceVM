# Joining CentOS based DSVM to Active Directory

This document shows how you can  join a CentOS based DSVM to your active directory domain. Thanks for Ankit and Alberto for coming up with the instructions and verifying it. 


Assumption: Your DSVM is connected to your VNet that hosts the corporate or Azure active directory


Here are the steps to this process. 

1. Login to your VM with the local credentials created during creation. This account will have sudo permissions
2. Run the following commands: 

<pre>
sudo yum install sssd realmd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation openldap-clients policycoreutils-python -y
sudo realm discover {FULLY QUALIFIED DOMAIN}
sudo realm join --user={DOMAINUSER} {FULLY QUALIFIED DOMAIN}
cat << EOD | sudo tee /etc/sssd/sssd.com > /dev/null

[sssd]
domains = {FULLY QUALIFIED DOMAIN}
config_file_version = 2
services = nss, pam

[domain/{FULLY QUALIFIED DOMAIN}]
ad_domain = {FULLY QUALIFIED DOMAIN}
krb5_realm = {FULLY QUALIFIED DOMAIN in CAPS}
realmd_tags = manages-system joined-with-samba
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = True
use_fully_qualified_names = False
fallback_homedir = /home/%u
access_provider = ad
EOF

systemctl restart sssd

</pre>

That is it. Your DSVM is now joined to active directory and your  users can login with their corp credentials. You can also login to JupyterHub using the Active directory credentials.  
