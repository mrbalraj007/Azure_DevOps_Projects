- Firewall needs to stop on all VMs
```sh
netsh advfirewall show all state
netsh advfirewall set allprofiles state off
```
[YouTube Link](https://www.youtube.com/watch?v=7b3LR8TvQVE&list=PLAwzouYxcpPjTtRB1FNQ5iLGkSaYD9JFb&index=14)

I'll create a new Terraform file for implementing Azure Firewall that gets created after the VNet, subnet, and virtual machines.

### [firewall.tf](file:///c%3A/Users/bsingh/OneDrive%20-%20Jetstar%20Airways%20Pty%20Ltd/Balraj_D_Laptop_Drive/DevOps_Master/Azure_DevOps_Projects/AZ-700_AzureNetworkEngineerAssociate/Day-11_VM_Firewall_Bastion_Host/firewall.tf)

```sh
This firewall configuration:

1. Creates a public IP for the Azure Firewall
2. Sets up a firewall policy with two rule collection groups:
   - Network rules to allow web (80/443), DNS (53), and RDP (3389) traffic
   - Application rules to allow Windows Update and other Microsoft services
3. Creates the Azure Firewall in the AzureFirewallSubnet that's already defined in your vnet
4. Includes a commented-out route that could be used to route traffic through the firewall instead of your NVA
5. Outputs the firewall's private and public IP addresses for reference
6. Uses dependencies to ensure the firewall is created after all VMs and network components

You can customize the rules according to your specific requirements.
```


```sh
I made the following changes:
1. Removed the security_group attribute from the AzureFirewallSubnet as Azure Firewall subnets cannot have an NSG attached to them
2. Also removed the security_group from the AzureBastionSubnet as it has special NSG requirements

These changes should resolve the deployment error. Azure Firewall comes with its own built-in security capabilities, so it doesn't need (and doesn't allow) an NSG attachment to its subnet.
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