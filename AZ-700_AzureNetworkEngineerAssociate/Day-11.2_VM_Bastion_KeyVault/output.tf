output "resource_group_name_01" {
  value = var.resource_group_name_01
}

output "location_01" {
  value = var.location_01
}

output "vm_centralindia_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-centralindia.name
}

output "vm_centralindia_private_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-centralindia-private.name
}

output "vm_centralindia_private_private_ip" {
  value = azurerm_network_interface.rg01_nic-centralindia-private.private_ip_address
}

# NVA VM outputs
output "vm_centralindia_nva_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-centralindia-nva.name
}

output "vm_centralindia_nva_private_ip" {
  value = azurerm_network_interface.rg01_nic-centralindia-nva.private_ip_address
}

# Bastion Host outputs
output "bastion_host_name" {
  value = azurerm_bastion_host.bastion_host.name
}

