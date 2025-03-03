- Firewall needs to stop on all VMs
```sh
netsh advfirewall show all state
netsh advfirewall set allprofiles state off
```


https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
