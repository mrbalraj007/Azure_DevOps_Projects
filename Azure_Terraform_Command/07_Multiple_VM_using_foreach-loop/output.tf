output "instance_ip_address" {
  value = [for ip in values(azurerm_linux_virtual_machine.example) : ip.public_ip_address]

}

output "instance_name" {
  value = [for vm in values(azurerm_linux_virtual_machine.example) : vm.name]

}