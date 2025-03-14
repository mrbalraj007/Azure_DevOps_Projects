# Generate a random suffix for globally unique Key Vault name
resource "random_string" "kv_suffix" {
  length  = 5
  special = false
  upper   = false
}

# Get the current client configuration from Azure
data "azurerm_client_config" "current" {}

# Create the Key Vault with policy-based access control
resource "azurerm_key_vault" "vm_keyvault" {
  name                        = "${var.keyvault_name}-${random_string.kv_suffix.result}"
  location                    = azurerm_resource_group.rg01.location
  resource_group_name         = azurerm_resource_group.rg01.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.keyvault_retention_days
  purge_protection_enabled    = var.keyvault_purge_protection

  sku_name = var.keyvault_sku

  # Policy-based Key Vault doesn't use network ACLs here, we rely on access policies
  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = {
    environment = var.tag_environment_vnet
  }
}

# Access policy for the deploying user (current client)
resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.vm_keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions      = var.kv_secret_permissions
  key_permissions         = var.kv_key_permissions
  certificate_permissions = var.kv_certificate_permissions
  storage_permissions     = var.kv_storage_permissions
}

# Access policy for the service principal (if provided)
resource "azurerm_key_vault_access_policy" "service_principal" {
  count = var.sp-user_object_id != "" ? 1 : 0

  key_vault_id = azurerm_key_vault.vm_keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.sp-user_object_id

  secret_permissions      = var.kv_secret_permissions
  key_permissions         = var.kv_key_permissions
  certificate_permissions = var.kv_certificate_permissions
  storage_permissions     = var.kv_storage_permissions
}

# Store VM credentials in Key Vault
resource "azurerm_key_vault_secret" "vm_username" {
  name         = "vm-username"
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.vm_keyvault.id

  depends_on = [
    azurerm_key_vault_access_policy.deployer
  ]
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-password"
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.vm_keyvault.id

  depends_on = [
    azurerm_key_vault_access_policy.deployer
  ]
}
