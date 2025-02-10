# This will create the resource group, storage account, and blob container.
resource "azurerm_resource_group" "str-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "str-acct" {
  name                     = "storageacct${substr(md5(var.resource_group_name), 0, 8)}"
  resource_group_name      = azurerm_resource_group.str-rg.name
  location                 = azurerm_resource_group.str-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "str-container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.str-acct.name
  container_access_type = "private"
  metadata = {
    key = "vnet.tfstate"
  }
}
