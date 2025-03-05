
This Traffic Manager configuration:

1. Creates a global Traffic Manager profile with Performance routing method
2. Sets up endpoints for all your VMs (two in East US and one in West US)
3. Configures health monitoring for each endpoint on HTTP port 80
4. Has priority-based failover (if East US VM1 fails, traffic goes to East US VM2, then West US)
5. Depends on the VMs and their extensions to ensure they're fully provisioned first
6. Outputs the Traffic Manager FQDN for easy access

The users will access your web servers via the Traffic Manager FQDN (az700-traffic-manager-demo.trafficmanager.net), and Traffic Manager will route them to the closest available endpoint based on performance metrics.

Made changes.




- Firewall needs to stop on all VMs
```sh
netsh advfirewall show all state
netsh advfirewall set allprofiles state off
```
[YouTube Link](https://www.youtube.com/watch?v=gA2jXYQMkAM&list=PLAwzouYxcpPjTtRB1FNQ5iLGkSaYD9JFb&index=9)

https://www.azurespeed.com/Azure/Latency

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_profile
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_azure_endpoint


https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb
https://github.com/Azure/terraform-azurerm-loadbalancer

https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-nat-pool-migration?tabs=azure-cli