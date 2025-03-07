- Firewall needs to stop on all VMs
```sh
netsh advfirewall show all state
netsh advfirewall set allprofiles state off
```
[YouTube Link](https://www.youtube.com/watch?v=ITxXBxRWXKc&list=PLAwzouYxcpPjTtRB1FNQ5iLGkSaYD9JFb&index=11)

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