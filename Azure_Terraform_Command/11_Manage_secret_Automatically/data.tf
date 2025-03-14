data "azurerm_client_config" "example" {}

data "azurerm_key_vault" "example" {
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.example.name
  depends_on          = [azurerm_key_vault.example]
}

data "azurerm_key_vault_secret" "username" {
  name         = "username"
  key_vault_id = data.azurerm_key_vault.example.id
  depends_on   = [azurerm_key_vault_secret.username]
}

data "azurerm_key_vault_secret" "password" {
  name         = "password"
  key_vault_id = data.azurerm_key_vault.example.id
  depends_on   = [azurerm_key_vault_secret.password]
}

