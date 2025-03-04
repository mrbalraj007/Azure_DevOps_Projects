- Firewall needs to stop on all VMs
```sh
netsh advfirewall show all state
netsh advfirewall set allprofiles state off
```
[YouTube Link](https://www.youtube.com/watch?v=sCUuFa2kbOc&list=PLAwzouYxcpPjTtRB1FNQ5iLGkSaYD9JFb&index=7)

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb
https://github.com/Azure/terraform-azurerm-loadbalancer

https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-nat-pool-migration?tabs=azure-cli