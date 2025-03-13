# Route table resource
resource "azurerm_route_table" "udr_route_table" {
  name                          = var.route_table_name
  location                      = var.location_01
  resource_group_name           = azurerm_resource_group.rg01.name
  bgp_route_propagation_enabled = true # Enable propagation of gateway routes

  tags = {
    environment = var.tag_environment_route_table
  }

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_windows_virtual_machine.rg01_vm-centralindia,
    azurerm_windows_virtual_machine.rg01_vm-centralindia-private,
    azurerm_windows_virtual_machine.rg01_vm-centralindia-nva,
    azurerm_firewall.fw # Ensure the firewall is created first
  ]
}

# Associate route table with the Public subnet
# Associate route table with the Private subnet
resource "azurerm_subnet_route_table_association" "private_subnet_rt_association" {
  #subnet_id      = "${azurerm_virtual_network.vnet1.id}/subnets/${var.centralindia_public_subnet_name}"
  subnet_id = "${azurerm_virtual_network.vnet1.id}/subnets/${var.centralindia_private_subnet_name}"

  route_table_id = azurerm_route_table.udr_route_table.id

  depends_on = [
    azurerm_route_table.udr_route_table,
    azurerm_firewall.fw
  ]
}

# # Route to NVA
# resource "azurerm_route" "to_nva" {
#   name                   = var.route_name_to_nva
#   resource_group_name    = azurerm_resource_group.rg01.name
#   route_table_name       = azurerm_route_table.udr_route_table.name
#   address_prefix         = var.route_address_prefix
#   next_hop_type          = var.next_hop_type
#   next_hop_in_ip_address = azurerm_network_interface.rg01_nic-centralindia-nva.private_ip_address

#   depends_on = [
#     azurerm_route_table.udr_route_table,
#     azurerm_network_interface.rg01_nic-centralindia-nva,
#     azurerm_firewall.fw
#   ]
# }

# Route for internet traffic via Firewall
resource "azurerm_route" "to_firewall" {
  name                   = var.route_name_to_firewall
  resource_group_name    = azurerm_resource_group.rg01.name
  route_table_name       = azurerm_route_table.udr_route_table.name
  address_prefix         = var.route_address_prefix
  next_hop_type          = var.next_hop_type
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address

  depends_on = [
    azurerm_route_table.udr_route_table,
    azurerm_firewall.fw
  ]
}

# Output the route table ID
output "route_table_id" {
  value = azurerm_route_table.udr_route_table.id
}

