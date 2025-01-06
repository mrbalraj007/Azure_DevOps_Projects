# output "aks_id" {
#   value = azurerm_kubernetes_cluster.aks.id
# }

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.example.name
}

output "public_ip" {
  value = azurerm_public_ip.example.ip_address
}

output "private_ip" {
  value = azurerm_network_interface.example.private_ip_address
}

output "container_registry_name" {
  value = azurerm_container_registry.example.name
}