# Sync On-Premises Active Directory with Azure AD

## Prerequisites

1. **Azure Subscription**: Ensure you have an active Azure subscription.
2. **Azure AD Tenant**: Create an Azure AD tenant if you don't have one.
3. **Azure AD Connect**: Download and install Azure AD Connect on a server in your on-premises environment.
4. **On-Premises Active Directory**: Ensure your on-premises Active Directory domain is functional and accessible.
5. **On-Premises Active Directory**: Ensure your on-premises Active Directory domain is having .net 4.7.2 and TLS 1.2 version installed


## Step-by-Step Guide

### Verify VM Status in Azure Console

![alt text](image.png)

### To disable Internet Explorer Enhanced Security Configuration.
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
***Explanation:***
- Enables TLS 1.2 for Client and Server in the SCHANNEL registry settings.
- Enables strong cryptography in .NET Framework, so applications use TLS 1.2 by default.
- Requires a system restart to fully apply the changes.

![alt text](image-3.png)


- Verified that TLS status on Server.
   



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
   - Choose the `Express Settings` option for a simple setup.

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
