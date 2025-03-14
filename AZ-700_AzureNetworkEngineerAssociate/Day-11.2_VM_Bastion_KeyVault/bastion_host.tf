// Public IP for Azure Bastion Host
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = var.bastion_public_ip_name
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.bastion_dns_label_prefix}-${random_string.dns_prefix.result}"
}

// Azure Bastion Host
resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_host_name
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  sku                 = "Standard" // Explicitly set to Standard SKU

  ip_configuration {
    name                 = var.bastion_ip_configuration_name
    subnet_id            = "${azurerm_virtual_network.vnet1.id}/subnets/AzureBastionSubnet"
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }

  # Significantly increase timeouts for Bastion Host
  timeouts {
    create = "60m" // Increase to 60 minutes
    update = "60m" // Increase to 60 minutes
    delete = "60m" // Increase to 60 minutes
    read   = "5m"
  }

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_public_ip.bastion_public_ip
  ]

  tags = {
    environment = var.tag_environment_vnet
  }
}
