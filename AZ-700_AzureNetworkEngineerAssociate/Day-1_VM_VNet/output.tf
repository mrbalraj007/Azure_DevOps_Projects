# output "resource_group_name" {
#   value = var.resource_group_name
# }

# output "location" {
#   value = var.location
# }

output "resource_group_name_rg01" {
  value = azurerm_resource_group.rg01.name
}

output "resource_group_name_rg02" {
  value = azurerm_resource_group.rg02.name
}

output "resource_group_name_rg03" {
  value = azurerm_resource_group.rg03.name
}

output "rg01_vm1_public_ip" {
  value = azurerm_public_ip.rg01_public_ip1.ip_address
}

output "rg01_vm2_public_ip" {
  value = azurerm_public_ip.rg01_public_ip2.ip_address
}

output "rg02_vm_public_ip" {
  value = azurerm_public_ip.rg02_public_ip.ip_address
}

output "rg03_vm_public_ip" {
  value = azurerm_public_ip.rg03_public_ip.ip_address
}

output "rg01_vm1_name" {
  value = azurerm_windows_virtual_machine.rg01_vm1.name
}

output "rg01_vm2_name" {
  value = azurerm_windows_virtual_machine.rg01_vm2.name
}

output "rg02_vm_name" {
  value = azurerm_windows_virtual_machine.rg02_vm.name
}

output "rg03_vm_name" {
  value = azurerm_windows_virtual_machine.rg03_vm.name
}

output "vnet1_name" {
  value = azurerm_virtual_network.vnet1.name
}

output "vnet2_name" {
  value = azurerm_virtual_network.vnet2.name
}

output "vnet3_name" {
  value = azurerm_virtual_network.vnet3.name
}

output "rg01_public_subnet_name" {
  value = data.azurerm_subnet.rg01_public.name
}

output "rg02_public_subnet_name" {
  value = data.azurerm_subnet.rg02_public.name
}

output "rg03_public_subnet_name" {
  value = data.azurerm_subnet.rg03_public.name
}

output "rg01_vm1_private_ip" {
  value = azurerm_network_interface.rg01_nic1.private_ip_address
}

output "rg01_vm2_private_ip" {
  value = azurerm_network_interface.rg01_nic2.private_ip_address
}

output "rg02_vm_private_ip" {
  value = azurerm_network_interface.rg02_nic.private_ip_address
}

output "rg03_vm_private_ip" {
  value = azurerm_network_interface.rg03_nic.private_ip_address
}

# output "project_name" {
#   value = var.project_name
# }

# output "azure_rm_service_connection_name" {
#   value = var.azure_rm_service_connection_name
# }

# output "azuredevops_serviceendpoint_aws" {
#   value = var.aws_service_connection_name
# }

# output "vm_name" {
#   value = azurerm_linux_virtual_machine.vm.name
# }

# output "private_ip_address" {
#   value = azurerm_network_interface.nic.private_ip_address
# }

# output "public_ip_address" {
#   value = azurerm_public_ip.public_ip.ip_address
# }
