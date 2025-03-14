# This will create the resource group, storage account, and blob container.
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "example" {
  name                     = "storageacct${substr(md5(var.resource_group_name), 0, 8)}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "scripts"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "user_data_software.sh"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = "Block"
  source                 = "${path.module}/scripts/user_data_software.sh"
}

resource "azurerm_role_assignment" "example" {
  principal_id   = data.azurerm_client_config.current.object_id
  role_definition_name = "Storage Blob Data Contributor"
  scope          = azurerm_storage_account.example.id
}

data "azurerm_client_config" "current" {}
