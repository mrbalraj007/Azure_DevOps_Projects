#### Verify Terraform Version

```sh
terraform --version
Terraform v1.9.2
on windows_386

Your version of Terraform is out of date! The latest version
is 1.10.2. You can update by downloading from https://www.terraform.io/downloads.html
```

```sh
Option 1: Using Environment Variables
You can set the following environment variables on your machine:

ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_TENANT_ID
ARM_SUBSCRIPTION_ID
For example, in a Unix-based system (Linux/MacOS), you can set them in the shell like this:

bash
Copy code
export ARM_CLIENT_ID="40bbf41d-b165-4ef2-xxxxxxxxxxxxx"
export ARM_CLIENT_SECRET="xxxxxxxxxxxxx"
export ARM_TENANT_ID="d504922d-ac26-4aa9-b625-xxxxxxxxxxxxx"
export ARM_SUBSCRIPTION_ID="2fc598a4-6a52-44b9-b476-xxxxxxxxxxxxx"
For Windows, you can set environment variables in PowerShell or Command Prompt:

powershell
Copy code
$env:ARM_CLIENT_ID="40bbf41d-b165-4ef2-xxxxxxxxxxxxx"
$env:ARM_CLIENT_SECRET="xxxxxxxxxxxxx"
$env:ARM_TENANT_ID="d504922d-ac26-4aa9-b625-xxxxxxxxxxxxx"
$env:ARM_SUBSCRIPTION_ID="2fc598a4-6a52-44b9-b476-xxxxxxxxxxxxx"

Terraform will automatically read these variables without the need to specify them in the provider block.
```

To remove or unset environment variables in PowerShell, you can use the Remove-Item cmdlet. Here's how you can remove the environment variables you previously set:

```powershell
Remove-Item -Path Env:ARM_CLIENT_ID
Remove-Item -Path Env:ARM_CLIENT_SECRET
Remove-Item -Path Env:ARM_TENANT_ID
Remove-Item -Path Env:ARM_SUBSCRIPTION_ID
```


[Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret

https://www.youtube.com/watch?v=Un2l16hFIpw&list=PLJcpyd04zn7rxl0X8mBdysb5NjUGIsJ7W&index=4

https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform?tabs=azure-cli
https://learn.microsoft.com/en-us/azure/developer/terraform/create-vm-scaleset-network-disks-hcl
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

[Azure linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)

[network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)

[Azure Public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)

[Azure Network interface security_group association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association)

[Azure CLI conceptual article list](https://learn.microsoft.com/en-us/cli/azure/reference-docs-index)
