output "resource_group_name_01" {
  value = var.resource_group_name_01
}

output "location_01" {
  value = var.location_01
}

output "vm1_name" {
  value = azurerm_windows_virtual_machine.rg01_vm1-eastus.name
}

output "vm2_name" {
  value = azurerm_windows_virtual_machine.rg01_vm2-eastus.name
}

output "vm_westus_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-westus.name
}

# Application Gateway outputs
output "app_gateway_id" {
  value = azurerm_application_gateway.app_gateway.id
  description = "The ID of the Application Gateway"
}

output "app_gateway_name" {
  value = azurerm_application_gateway.app_gateway.name
  description = "The name of the Application Gateway"
}

output "app_gateway_public_ip" {
  value = azurerm_public_ip.app_gateway_public_ip.ip_address
  description = "The public IP address of the Application Gateway"
}

output "app_gateway_backend_addresses" {
  value = [
    azurerm_network_interface.rg01_nic1-eastus.private_ip_address,
    azurerm_network_interface.rg01_nic2-eastus.private_ip_address
  ]
  description = "The backend addresses of the Application Gateway"
}

# Add path-based routing URLs
output "app_gateway_image_url" {
  value = "http://${azurerm_public_ip.app_gateway_public_ip.ip_address}/images/"
  description = "URL to access images via path-based routing"
}

output "app_gateway_video_url" {
  value = "http://${azurerm_public_ip.app_gateway_public_ip.ip_address}/videos/ (NOTE: This path may not work; use direct URL below)"
  description = "URL to access videos via path-based routing (May not work)"
}

output "direct_videos_url" {
  value = "http://${azurerm_public_ip.rg01_public_ip2-eastus.ip_address}/videos/ (RECOMMENDED: Use this direct URL for videos)"
  description = "Direct URL to access videos on VM02 (Working)"
}

output "workaround_note" {
  value = "To access videos, please use the direct URL shown above. Check README.md and videos_access.html for more information."
}

output "app_gateway_host_based_images_url" {
  value = "http://images.example.com (point this hostname to ${azurerm_public_ip.app_gateway_public_ip.ip_address} in your hosts file)"
  description = "URL to access images via host-based routing"
}

output "app_gateway_host_based_videos_url" {
  value = "http://videos.example.com (point this hostname to ${azurerm_public_ip.app_gateway_public_ip.ip_address} in your hosts file)"
  description = "URL to access videos via host-based routing"
}

output "app_gateway_path_based_url" {
  value = "http://content.example.com (point this hostname to ${azurerm_public_ip.app_gateway_public_ip.ip_address} in your hosts file)"
  description = "URL to access content via path-based routing (use /images/ or /videos/ path)"
}
