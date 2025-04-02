# **Seamlessly Integrate On-Premises Active Directory with Azure AD**

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

*I have created a Terraform code to set up the Virtual Machine creations and installation of Active Direcotry, Users, Groups and Service Account automatically created.*

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
      -rw-r--r-- 1 bsingh 1049089  2309 Mar 26 20:29 Configure-AD-Users.ps1
      -rw-r--r-- 1 bsingh 1049089  7705 Mar 31 12:37 Configure-AD-Users-and-Groups.ps1
      -rw-r--r-- 1 bsingh 1049089  6842 Mar 26 20:29 Install-AD.ps1
      -rw-r--r-- 1 bsingh 1049089  6912 Mar 31 11:31 main.tf
      -rw-r--r-- 1 bsingh 1049089   492 Mar 26 17:14 terraform.tfvars
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
![alt text](image-8.png)
Once you run the terraform command, then we will verify the following things to make sure everything is setup via a terraform.

### <span style="color: Orange;"> Inspect the ```C:\WindowsAzure``` logs</span>: 
Once connected to VM then you can check the status of the ```CustomScript``` script by inspecting the log files

![alt text](image-9.png)
![alt text](image-10.png)

### <span style="color: cyan;"> Verify the Installation 


#### Verify `Virtual Machine` Status in Azure Console

![alt text](image.png)

### Verify `Users, Groups` and `Service account` in Active Directory.
![alt text](image-11.png)

### Permission to service account in Active Directory.
- Below are the permissions need to assign to service account in Active Directory.
![alt text](image-69.png)

### Verify `storage account` and `blob`.
![alt text](image-12.png)


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
*- Enables TLS 1.2 for Client and Server in the SCHANNEL registry settings.
- Enables strong cryptography in .NET Framework, so applications use TLS 1.2 by default.
- Requires a system restart to fully apply the changes.*

- Verified that `TLS status` on Server.
   ![alt text](image-4.png)


### Step 1: Prepare Azure AD

1. **Login to Azure Portal**: Go to [Azure Portal](https://portal.azure.com) and log in with your Azure account.
2. **Create Azure AD Tenant**:
   - Navigate to `Microsoft Intra ID` > `Create a directory`.
   - Follow the prompts to create a new directory.
3. **Create new admin user for migration**:
   - Will create a new user in Azure AD and assign the `global administrator` rights.
   ![alt text](image-14.png)
   ![alt text](image-15.png)

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
   - select the Sign On Method
   ![alt text](image-13.png)
   
3. **Configure Azure AD Connect**:
   - During the setup, you will be prompted to enter your Azure AD and on-premises AD credentials.
   - Type the user which created in Step 1 which has `global administrator` rights select the Sign On Method
   ![alt text](image-16.png)
   ![alt text](image-17.png)
   - Select the `Singh.org.au` domain for synchronization and click on add directory.
   ![alt text](image-18.png)
   - select `use existing AD Account` and type `service account` details.
   ![alt text](image-19.png)
   ![alt text](image-20.png)
   - click on `Continue without matching all UPN suffixes to verified domains`
   ![alt text](image-21.png)

   - Click on `Sync selected domains and OUs`
   ![alt text](image-22.png)
   - leave the default setting and click next.
   ![alt text](image-23.png)
   ![alt text](image-24.png)
   ![alt text](image-25.png)
   - Choose the synchronization options that best fit your environment (e.g., password hash synchronization, pass-through authentication).
   ![alt text](image-26.png)
   ![alt text](image-27.png)
### Step 3: Verify Synchronization

1. **Initial Sync**:
   - Once the setup is complete, Azure AD Connect will perform an initial synchronization.
   - You can monitor the sync status in the Azure AD Connect tool.

2. **Verify Users in Azure AD**:
   - Go to `Azure Active Directory` > `Users` in the Azure Portal.
   - Verify that the on-premises AD users are listed in Azure AD.
   - Users Status
   ![alt text](image-28.png)
   - Group Status
   ![alt text](image-29.png)
   ![alt text](image-30.png)
### Step 4: Configure Additional Settings (Optional)

1. **Password Writeback**:
   - If you want to enable password writeback, configure it in the Azure AD Connect tool.
   - This allows users to change their passwords in Azure AD and have them written back to the on-premises AD.

2. **Single Sign-On (SSO)**:
   - Configure SSO to allow users to sign in once and access both on-premises and cloud resources.

## Error and Troubleshooting.


- I was not able to login with user account and noticed that users were getting permission issue.

**Fix**
- I used service account to configure to migrate the AD but didn't provide permission at domain level.

- So, I have granted the permission to service account at domain level and also initiate the following powershell to sync the delta and verify in service manager.
![alt text](image-69.png)

```sh
Start-ADSyncSyncCycle -PolicyType Delta
Start-ADSyncSyncCycle -PolicyType initial
```

![alt text](image-70.png)

### Delete Azure Security Group (Optional)
```sh
az ad group delete --group 'GroupName' --verbose
```


### Conclusion

By following these steps, you will have successfully synchronized your on-premises Active Directory with Azure AD. This setup ensures that your users can access both on-premises and cloud resources with a single set of credentials.


**Ref Link**
- [sync on-premises Active Directory to Azure Active Directory with Azure AD Connect](https://www.codetwo.com/admins-blog/how-to-sync-on-premises-active-directory-to-azure-active-directory-with-azure-ad-connect/)

