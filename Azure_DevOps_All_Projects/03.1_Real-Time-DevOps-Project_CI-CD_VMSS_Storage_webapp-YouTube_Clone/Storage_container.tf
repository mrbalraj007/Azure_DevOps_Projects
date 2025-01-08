resource "azurerm_storage_account" "example" {
  name                     = "storageacct${substr(md5(var.resource_group_name), 0, 8)}"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
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
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.example.id
}

resource "azurerm_role_assignment" "vmss_storage_blob_data_contributor" {
  principal_id         = azurerm_linux_virtual_machine_scale_set.vmss.identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.example.id
  depends_on           = [azurerm_linux_virtual_machine_scale_set.vmss]
}

data "azurerm_client_config" "current" {}
