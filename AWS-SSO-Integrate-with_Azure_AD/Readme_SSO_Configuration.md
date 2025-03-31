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



```sh
singh.org.au

DSRM: d0ma!n@2026
Roro751682
Roro286157- active
P@ssw0rd123 - users

svc_ad_admin_migration
test@123456
```