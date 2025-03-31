output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "vm_name" {
  value = azurerm_windows_virtual_machine.vm.name
}
