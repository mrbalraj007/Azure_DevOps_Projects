Ref- 

[Youtube Video](https://www.youtube.com/watch?v=eUnpRgcgluA&list=PLj2ea3LWzneW5GSRRCvVvjn4croHn4Ev-&index=6)

- [azure-cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

- [Azure Backend State file](https://developer.hashicorp.com/terraform/language/backend/azurerm)

![image](https://github.com/user-attachments/assets/4ba070a2-6589-4ecd-8ad2-a3fc1a054187)
![image-1](https://github.com/user-attachments/assets/fb72d249-ed87-4ae3-b9a1-5d0c43f512c9)

- To create the whole setup (resource group, storage account, blob container, and then use that for storing the state file) in a single Terraform run, you need to use a remote backend in such a way that Terraform can create the resources in Azure first and then store the state file remotely. However, Terraform does not allow configuring a remote backend dynamically from within the same execution plan.

- The workaround to achieve this is as follows:

- Use a local backend initially to apply the infrastructure creation.
- Reconfigure the backend to azurerm for the state storage once the infrastructure (resource group, storage account, blob container) is created.
- The challenge is that you cannot define the remote backend during the initial terraform init directly. However, we can break it into two phases within the same process using the following approach:

### Solution Approach:
- Phase 1: Use a local backend to apply and create the necessary resources (resource group, storage account, and blob container).
- Phase 2: After creating the resources, reconfigure the backend to use Azure for state storage and reinitialize.
- Since Terraform doesn't allow creating a backend configuration dynamically during the run, you can automate this process with two distinct steps:


Execution Plan:
Initial terraform init and apply: Initially, Terraform uses a local backend to apply the infrastructure changes (resource group, storage account, blob container) in the same step.

```bash
terraform init
terraform apply
```
Note--> Note it down the output value and update in backend.tf file in folder ```Step02.```
#### Reconfigure backend to azurerm: 
Once the resources are created, we need to manually change the backend configuration to use the Azure storage account and container for the state file.

- Modify backend.tf:

```bash
terraform {
  backend "azurerm" {
    resource_group_name  = "testRG"
    storage_account_name = "storageacctf834da40"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

```
Reinitialize Terraform: Reinitialize Terraform to start using the new backend.

```bash
terraform init -reconfigure
```
Summary:
While Terraform doesn't natively support dynamically configuring the backend during a single execution, this approach allows you to:

Create the resource group, storage account, and container with a local state.
After applying the resources, reconfigure the backend to use the newly created resources for state storage.


- Phase 1: Use a local backend to create the resources.
- Phase 2: After creating the resources, modify the backend.tf to use the Azure storage container and run terraform init -reconfigure to switch the backend to Azure.



