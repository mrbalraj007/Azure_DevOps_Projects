# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Create a globally unique name for the Key Vault
resource "random_string" "keyvault_name_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Create the Azure Key Vault with access policies
resource "azurerm_key_vault" "vm_key_vault" {
  name                       = "${var.keyvault_name}-${random_string.keyvault_name_suffix.result}"
  location                   = var.location_01
  resource_group_name        = azurerm_resource_group.rg01.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.keyvault_sku
  soft_delete_retention_days = var.keyvault_retention_days
  purge_protection_enabled   = var.keyvault_purge_protection

  # Using access policies, not RBAC
  enable_rbac_authorization = false

  # Allow public network access
  public_network_access_enabled = true

  # Network ACLs - Allow all access by default
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = {
    environment = var.tag_environment_vnet
  }

  depends_on = [
    azurerm_resource_group.rg01
  ]
}

# Access policy for the service principal (Terraform)
resource "azurerm_key_vault_access_policy" "terraform_sp" {
  key_vault_id = azurerm_key_vault.vm_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions      = var.kv_secret_permissions
  key_permissions         = var.kv_key_permissions
  certificate_permissions = var.kv_certificate_permissions
  storage_permissions     = var.kv_storage_permissions

  depends_on = [
    azurerm_key_vault.vm_key_vault
  ]
}

# Access policy for the specified service principal user
resource "azurerm_key_vault_access_policy" "user_sp" {
  count = var.sp-user_object_id != "" ? 1 : 0

  key_vault_id = azurerm_key_vault.vm_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.sp-user_object_id

  secret_permissions      = var.kv_secret_permissions
  key_permissions         = var.kv_key_permissions
  certificate_permissions = var.kv_certificate_permissions
  storage_permissions     = var.kv_storage_permissions

  depends_on = [
    azurerm_key_vault.vm_key_vault,
    azurerm_key_vault_access_policy.terraform_sp
  ]
}

# Store VM credentials in Key Vault
resource "azurerm_key_vault_secret" "admin_username" {
  name         = "vm-admin-username"
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.vm_key_vault.id

  depends_on = [
    azurerm_key_vault.vm_key_vault,
    azurerm_key_vault_access_policy.terraform_sp
  ]
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "vm-admin-password"
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.vm_key_vault.id

  depends_on = [
    azurerm_key_vault.vm_key_vault,
    azurerm_key_vault_access_policy.terraform_sp
  ]
}

# Output information for troubleshooting
output "key_vault_name" {
  value = azurerm_key_vault.vm_key_vault.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.vm_key_vault.vault_uri
}

output "current_object_id" {
  value = data.azurerm_client_config.current.object_id
}

output "current_tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "sp_user_object_id" {
  value = var.sp-user_object_id
}

