# Sync On-Premises Active Directory with Azure AD

## Prerequisites

1. **Azure Subscription**: Ensure you have an active Azure subscription.
2. **Azure AD Tenant**: Create an Azure AD tenant if you don't have one.
3. **Azure AD Connect**: Download and install Azure AD Connect on a server in your on-premises environment.
4. **On-Premises Active Directory**: Ensure your on-premises Active Directory domain is functional and accessible.
5. **On-Premises Active Directory**: Ensure your on-premises Active Directory domain is having .net 4.7.2 and TLS 1.2 version installed
6. [Terraform code for Infra setup](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/AWS-SSO-Integrate-with_Azure_AD/Terraform_Code_Azure_VM)<br>
   > __Note__: Replace resource names and variables as per your requirement in terraform code
      - Update values in```terraform.tfvars```


## Step-by-Step Guide

### <span style="color: Yellow;">Setting Up the Infrastructure </span>

I have created a Terraform code to set up the Virtual Machine creations and installation of Active Direcotry, Users, Groups and Service Account automatically created.

> **Note**--> Virtual Machine will take approx 10 to 15 min to install the all required setup.

- &rArr; <span style="color: brown;">Virtual machines will be created named as ```"ad-server"```

- &rArr;<span style="color: brown;"> Active Direcotry install
- &rArr;<span style="color: brown;"> Will create users, Groups and Service account
- &rArr;<span style="color: brown;"> Storage Acccount & Blob Setup

First, we'll create the necessary virtual machines using ```terraform``` code. 

  - Below is a terraform Code:

  - Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/AWS-SSO-Integrate-with_Azure_AD/Terraform_Code_Azure_VM)</span> and run the terraform command.
    ```bash
    $ ls -l
    -rw-r--r-- 1 bsingh 1049089   573 Feb 19 15:37 aws_connection.tf       
    -rw-r--r-- 1 bsingh 1049089   876 Feb 24 15:57 azure_rm_connection.tf  
    -rw-r--r-- 1 bsingh 1049089   564 Feb 19 13:54 DevOps_UI.tf
    -rw-r--r-- 1 bsingh 1049089   419 Feb 19 13:55 group_lib.tf
    -rw-r--r-- 1 bsingh 1049089  3243 Feb 27 10:59 id_rsa
    -rw-r--r-- 1 bsingh 1049089   725 Feb 27 10:59 id_rsa.pub
    -rw-r--r-- 1 bsingh 1049089   769 Feb 20 11:27 output.tf
    -rw-r--r-- 1 bsingh 1049089   528 Feb 18 21:13 provider.tf
    drwxr-xr-x 1 bsingh 1049089     0 Feb 20 15:59 scripts/
    -rw-r--r-- 1 bsingh 1049089  6175 Feb 20 15:57 selfthost_agentvm.tf    
    -rw-r--r-- 1 bsingh 1049089   362 Feb 19 12:35 ssh_key.tf
    -rw-r--r-- 1 bsingh 1049089  1180 Feb 21 12:44 Storage.tf
    -rw-r--r-- 1 bsingh 1049089 72270 Feb 27 11:02 terraform.tfstate       
    -rw-r--r-- 1 bsingh 1049089   183 Feb 27 10:59 terraform.tfstate.backup
    -rw-r--r-- 1 bsingh 1049089  3654 Feb 21 13:13 terraform.tfvars        
    -rw-r--r-- 1 bsingh 1049089  3999 Feb 20 11:05 variable.tf
    ```

- You need to run terraform command.
  - Run the following command.
  ```bash
  terraform init
  terraform fmt
  terraform validate
  terraform plan
  terraform apply 
  # Optional <terraform apply --auto-approve>
  ```
![Image](https://github.com/user-attachments/assets/ec2fb16f-d7f5-4de6-9831-b9a64829dc7d)
Once you run the terraform command, then we will verify the following things to make sure everything is setup via a terraform.

### <span style="color: Orange;"> Inspect the ```Cloud-Init``` logs</span>: 
Once connected to VM then you can check the status of the ```user_data``` script by inspecting the log files
```bash
# Primary log file for cloud-init
sudo tail -f /var/log/cloud-init-output.log
                    or 
sudo cat /var/log/cloud-init-output.log | more
```
- *If the user_data script runs successfully, you will see output logs and any errors encountered during execution.*
- *If there’s an error, this log will provide clues about what failed.*

![Image](https://github.com/user-attachments/assets/27233f0b-3fab-49ec-893e-8c24431e0ebb)


### <span style="color: cyan;"> Verify the Installation 

- [x] <span style="color: brown;"> Docker version
```bash
azureuser@devopsdemovm:~$  docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1


docker ps -a
azureuser@devopsdemovm:~$  docker ps
```
- [x] <span style="color: brown;"> Ansible version
```bash
azureuser@devopsdemovm:~$ ansible --version
ansible [core 2.17.8]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/azureuser/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/azureuser/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.12 (main, Feb  4 2025, 14:57:36) [GCC 11.4.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True
```
- [x] <span style="color: brown;"> Azure CLI version
```bash
azureuser@devopsdemovm:~$ az version
{
  "azure-cli": "2.67.0",
  "azure-cli-core": "2.67.0",
  "azure-cli-telemetry": "1.1.0",
  "extensions": {}
}
```
- [x] <span style="color: brown;"> Project Creation
![Image](https://github.com/user-attachments/assets/c641826f-9db1-431b-a27c-a0d57669ae37)
- [x] <span style="color: brown;"> Service Connection
![Image](https://github.com/user-attachments/assets/a7952cbf-b200-4209-ad5e-732b23647c23)
- [x] <span style="color: brown;"> Import Repo 
![Image](https://github.com/user-attachments/assets/eb5e0859-87c7-4cef-8518-f9713b432306)
- [x] <span style="color: brown;"> Resource Group & Storage account Creation
![Image](https://github.com/user-attachments/assets/ed3ac689-7877-4128-b85d-80b8aedb51dc)

- Upload the private and public keys in library from a secure files as below.
![Image](https://github.com/user-attachments/assets/11cae9a2-e347-40d3-81b0-996616a28f7f)

**Note**: It would be the same keys which was created during the provision the infra.

### Verify Virtual Machine Status in Azure Console

![alt text](image.png)

### Verify Users, Groups and Service account in Virtual Machine.






### To disable `Internet Explorer Enhanced Security Configuration`.
![alt text](image-1.png)

### To Verify TLS Status

#### To check whether TLS 1.2 is enabled on a Windows system using PowerShell, you can run the following command:

```powershell
[Net.ServicePointManager]::SecurityProtocol.HasFlag([Net.SecurityProtocolType]::Tls12)
```
If TLS 1.2 is enabled, this will return True. Otherwise, it will return False.

#### Alternative Method: Checking the Registry
You can also check the Windows registry to see if TLS 1.2 is explicitly enabled:
```powershell
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
$enabled = Get-ItemProperty -Path $registryPath -Name "Enabled" -ErrorAction SilentlyContinue

if ($enabled -and $enabled.Enabled -eq 1) {
    Write-Output "TLS 1.2 is enabled."
} else {
    Write-Output "TLS 1.2 is NOT enabled."
}
```

- Verified that TLS is not enabled on Server.
   ![alt text](image-2.png)


### To enable TLS 1.2 on both Client and Server in Windows

#### To enable TLS 1.2 on both Client and Server in Windows, use the following PowerShell command:

```powershell
# Enable TLS 1.2 for Client
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Name "Enabled" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Name "DisabledByDefault" -Value 0 -Type DWord

# Enable TLS 1.2 for Server
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Name "Enabled" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Name "DisabledByDefault" -Value 0 -Type DWord

# Enable TLS 1.2 for .NET Framework (for older apps)
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Value 1 -PropertyType DWord -Force | Out-Null

Write-Output "TLS 1.2 has been enabled. A system restart is recommended for changes to take effect."
```
![alt text](image-3.png)

***Explanation:***
- Enables TLS 1.2 for Client and Server in the SCHANNEL registry settings.
- Enables strong cryptography in .NET Framework, so applications use TLS 1.2 by default.
- Requires a system restart to fully apply the changes.

- Verified that TLS status on Server.
   ![alt text](image-4.png)


### Step 1: Prepare Azure AD

1. **Login to Azure Portal**: Go to [Azure Portal](https://portal.azure.com) and log in with your Azure account.
2. **Create Azure AD Tenant**:
   - Navigate to `Azure Active Directory` > `Create a directory`.
   - Follow the prompts to create a new directory.

### Step 2: Configure Azure AD Connect

1. **Download Azure AD Connect**:
   - Go to the [Azure AD Connect download page](https://www.microsoft.com/en-us/download/details.aspx?id=47594) and download the latest version.

2. **Install Azure AD Connect**:
   - Run the installer on a server in your on-premises environment.
   ![alt text](image-5.png)

   - Choose the `Customize` option for a simple setup.
   ![alt text](image-6.png)
   - leave as it is and click on install
   ![alt text](image-7.png)


3. **Configure Azure AD Connect**:
   - During the setup, you will be prompted to enter your Azure AD and on-premises AD credentials.
   - Select the `Singh.org.au` domain for synchronization.
   - Choose the synchronization options that best fit your environment (e.g., password hash synchronization, pass-through authentication).

### Step 3: Verify Synchronization

1. **Initial Sync**:
   - Once the setup is complete, Azure AD Connect will perform an initial synchronization.
   - You can monitor the sync status in the Azure AD Connect tool.

2. **Verify Users in Azure AD**:
   - Go to `Azure Active Directory` > `Users` in the Azure Portal.
   - Verify that the on-premises AD users are listed in Azure AD.

### Step 4: Configure Additional Settings (Optional)

1. **Password Writeback**:
   - If you want to enable password writeback, configure it in the Azure AD Connect tool.
   - This allows users to change their passwords in Azure AD and have them written back to the on-premises AD.

2. **Single Sign-On (SSO)**:
   - Configure SSO to allow users to sign in once and access both on-premises and cloud resources.

### Conclusion

By following these steps, you will have successfully synchronized your on-premises Active Directory with Azure AD. This setup ensures that your users can access both on-premises and cloud resources with a single set of credentials.

```sh
az ad group delete --group 'GroupName' --verbose
```
