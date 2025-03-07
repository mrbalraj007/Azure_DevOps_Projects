# Public IP for NAT Gateway
resource "azurerm_public_ip" "natgw_public_ip" {
  name                = var.natgw_public_ip_name
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = var.natgw_public_ip_allocation
  sku                 = var.natgw_public_ip_sku
  zones               = var.natgw_public_ip_zones

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_windows_virtual_machine.rg01_vm-centralindia,
    azurerm_windows_virtual_machine.rg01_vm-centralindia-private
  ]
}

# NAT Gateway resource
resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = var.nat_gateway_name
  location                = var.location_01
  resource_group_name     = azurerm_resource_group.rg01.name
  sku_name                = var.nat_gateway_sku
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout

  depends_on = [
    azurerm_public_ip.natgw_public_ip,
    azurerm_virtual_network.vnet1,
    azurerm_windows_virtual_machine.rg01_vm-centralindia,
    azurerm_windows_virtual_machine.rg01_vm-centralindia-private
  ]
}

# Associate public IP with NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "natgw_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.natgw_public_ip.id

  depends_on = [
    azurerm_nat_gateway.nat_gateway,
    azurerm_public_ip.natgw_public_ip
  ]
}

# Get the private subnet ID
data "azurerm_subnet" "private_subnet" {
  name                 = var.centralindia_private_subnet_name
  virtual_network_name = var.name_az700-rg01-centralindia-vnet-01
  resource_group_name  = azurerm_resource_group.rg01.name
  depends_on           = [azurerm_virtual_network.vnet1]
}

# Associate NAT Gateway with the private subnet - using azurerm_subnet_nat_gateway_association
resource "azurerm_subnet_nat_gateway_association" "private_subnet_natgw" {
  subnet_id      = "${azurerm_virtual_network.vnet1.id}/subnets/${var.centralindia_private_subnet_name}"
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id

  depends_on = [
    azurerm_nat_gateway.nat_gateway,
    azurerm_virtual_network.vnet1,
    azurerm_windows_virtual_machine.rg01_vm-centralindia,
    azurerm_windows_virtual_machine.rg01_vm-centralindia-private
  ]
}
