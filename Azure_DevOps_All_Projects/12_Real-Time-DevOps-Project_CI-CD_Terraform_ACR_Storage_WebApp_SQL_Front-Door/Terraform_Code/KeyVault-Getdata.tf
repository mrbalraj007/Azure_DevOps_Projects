data "azurerm_client_config" "clientconfig" {}

data "azurerm_key_vault" "keyvault" {
  name                = "${var.key_vault_name}-${random_string.keyvault_suffix.result}"
  resource_group_name = azurerm_resource_group.rgname.name
  depends_on          = [azurerm_key_vault.keyvault]
}

data "azurerm_key_vault_secret" "servicePrincipalId" {
  name         = "servicePrincipalId"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault_secret.servicePrincipalId]
}

data "azurerm_key_vault_secret" "servicePrincipalKey" {
  name         = "servicePrincipalKey"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault_secret.servicePrincipalKey]
}

data "azurerm_key_vault_secret" "tenantid" {
  name         = "tenantid"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault_secret.tenantid]
}

