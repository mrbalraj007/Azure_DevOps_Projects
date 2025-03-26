```sh
============
#
# Windows PowerShell script for AD DS Deployment
#
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "singh.org.au" `
-DomainNetbiosName "SINGH" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
=============
```

https://www.readandexecute.com/how-to/server-2016/active-directory/how-to-server-2016installing-active-directory-server-2016/

https://www.microsoft.com/en-us/download/details.aspx?id=47594
https://learn.microsoft.com/en-us/entra/identity/saas-apps/amazon-web-service-tutorial

```sh
singh.org.au

DSRM: d0ma!n@2026
Roro751682
Roro286157- active

svc_ad_admin_migration
test@123456
```