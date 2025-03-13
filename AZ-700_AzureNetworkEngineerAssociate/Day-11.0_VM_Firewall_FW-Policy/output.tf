output "resource_group_name_01" {
  value = var.resource_group_name_01
}

output "location_01" {
  value = var.location_01
}

output "vm_centralindia_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-centralindia.name
}

output "vm_centralindia_public_ip" {
  value = azurerm_public_ip.rg01_public_ip-centralindia.ip_address
}

output "vm_centralindia_fqdn" {
  value = azurerm_public_ip.rg01_public_ip-centralindia.fqdn
}

output "vm_centralindia_private_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-centralindia-private.name
}

output "vm_centralindia_private_public_ip" {
  value = azurerm_public_ip.rg01_public_ip-centralindia-private.ip_address
}

output "vm_centralindia_private_private_ip" {
  value = azurerm_network_interface.rg01_nic-centralindia-private.private_ip_address
}

output "vm_centralindia_private_fqdn" {
  value = azurerm_public_ip.rg01_public_ip-centralindia-private.fqdn
}

# NVA VM outputs
output "vm_centralindia_nva_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-centralindia-nva.name
}

output "vm_centralindia_nva_public_ip" {
  value = azurerm_public_ip.rg01_public_ip-centralindia-nva.ip_address
}

output "vm_centralindia_nva_private_ip" {
  value = azurerm_network_interface.rg01_nic-centralindia-nva.private_ip_address
}

output "vm_centralindia_nva_fqdn" {
  value = azurerm_public_ip.rg01_public_ip-centralindia-nva.fqdn
}

