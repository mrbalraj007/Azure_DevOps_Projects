- Firewall needs to stop on all VMs
```sh
netsh advfirewall show all state
netsh advfirewall set allprofiles state off
```
[YouTube Link](https://www.youtube.com/watch?v=7b3LR8TvQVE&list=PLAwzouYxcpPjTtRB1FNQ5iLGkSaYD9JFb&index=14)

```sh
az ad signed-in-user show --query objectId -o tsv
# For signed-in user
az ad signed-in-user show --query objectId -o tsv

# For service principal
az ad sp list --display-name "YOUR-SERVICE-PRINCIPAL-NAME" --query "[].objectId" -o tsv
```
```sh
1. First, find the current IDs of your secrets:
   ```bash
   # Replace 'vmcreds-kv-jzx55b' with your actual Key Vault name
   KEYVAULT_NAME=$(terraform output -raw key_vault_name)
   
   # Get the username secret ID
   USERNAME_SECRET_ID=$(az keyvault secret show --vault-name $KEYVAULT_NAME --name vm-admin-username --query id -o tsv)
   
   # Get the password secret ID
   PASSWORD_SECRET_ID=$(az keyvault secret show --vault-name $KEYVAULT_NAME --name vm-admin-password --query id -o tsv)
   
   echo "Username Secret ID: $USERNAME_SECRET_ID"
   echo "Password Secret ID: $PASSWORD_SECRET_ID"
   ```

2. Import the existing secrets into the Terraform state:
   ```bash
   # Import username secret
   terraform import azurerm_key_vault_secret.admin_username "$USERNAME_SECRET_ID"
   
   # Import password secret
   terraform import azurerm_key_vault_secret.admin_password "$PASSWORD_SECRET_ID"
   ```

3. After successful import, uncomment the secret resources in the keyvault.tf file

This approach:
1. Comments out the secret resources to prevent conflicts with existing resources
2. Provides clear import commands to bring existing resources into Terraform state
3. Keeps your Key Vault configuration clean and maintainable after importing the resources
```

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table

https://github.com/kumarvna/terraform-azurerm-nat-gateway/blob/main/main.tf


https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/frontdoor


https://www.azurespeed.com/Azure/Latency

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_profile
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_azure_endpoint


https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb
https://github.com/Azure/terraform-azurerm-loadbalancer

https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-nat-pool-migration?tabs=azure-cli