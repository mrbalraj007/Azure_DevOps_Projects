data "azurerm_key_vault" "example" {
  name                = "vault02012025"
  resource_group_name = "secret-test"
}

data "azurerm_key_vault_secret" "example" {
  name         = "username" # define the name of the secret
  key_vault_id = data.azurerm_key_vault.example.id
}


data "azurerm_key_vault_secret" "example1" {
  name         = "password" # define the name of the password
  key_vault_id = data.azurerm_key_vault.example.id
}

