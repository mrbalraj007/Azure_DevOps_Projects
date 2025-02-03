resource "random_string" "keyvault_suffix" {
  length  = var.random_string_length
  special = false
}

resource "azurerm_resource_group" "rgname" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_key_vault" "keyvault" {
  name                = "${var.key_vault_name}-${random_string.keyvault_suffix.result}"
  location            = azurerm_resource_group.rgname.location
  resource_group_name = azurerm_resource_group.rgname.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.clientconfig.tenant_id

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.clientconfig.tenant_id
    object_id = data.azurerm_client_config.clientconfig.object_id

    key_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"
    ]
    certificate_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.clientconfig.tenant_id
    # object_id = "40bbf41d-b165-4ef2-8d0b-a25409ffc5a2" # Replace with actual object ID
    object_id = var.azure_sp_object_id
    key_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"
    ]
    certificate_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.clientconfig.tenant_id
    #object_id = "083498eb-118c-4d4c-bf3d-341da1cf5063" # Balraj Singh's Object ID
    object_id = var.azure_sp_object_id
    key_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"
    ]
    certificate_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }
}

resource "azurerm_key_vault_secret" "servicePrincipalId" {
  name         = "servicePrincipalId"
  value        = var.servicePrincipalId
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "servicePrincipalKey" {
  name         = "servicePrincipalKey"
  value        = var.servicePrincipalKey
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "tenantid" {
  name         = "tenantid"
  value        = var.tenantid
  key_vault_id = azurerm_key_vault.keyvault.id
}
