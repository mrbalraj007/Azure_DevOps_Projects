# This will create the resource group, storage account, and blob container.
resource "azurerm_resource_group" "str-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_storage_account" "str-acct" {
  name                     = "storageacct${substr(md5(var.resource_group_name), 0, 8)}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.str-rg.name
  location                 = azurerm_resource_group.str-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.str-rg]
}

resource "time_sleep" "wait_for_storage_account" {
  depends_on      = [azurerm_storage_account.str-acct]
  create_duration = "60s"
}

resource "azurerm_storage_container" "str-container" {
  name                  = "tfstates"
  storage_account_name  = azurerm_storage_account.str-acct.name
  container_access_type = "private"
  metadata = {
    key = "terraform.tfstates"
  }
  depends_on = [time_sleep.wait_for_storage_account]
}
