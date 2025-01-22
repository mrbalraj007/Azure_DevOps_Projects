resource "random_id" "acr" {
  keepers = {
    # Generate a new id each time the resource group name changes
    resource_group_name = var.resource_group_name
  }

  byte_length = 4
}

resource "azurerm_container_registry" "acr" {
  name                = "aconreg${random_id.acr.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true

  tags = {
    environment = "test"
  }
}