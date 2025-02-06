# output "agent_pool_name" {
#   value = var.agent_pool_name
# }

output "repository_name" {
  value = var.repository_name
}

output "repository_name1" {
  value = var.repository_name1
}

output "resource_group_name" {
  value = azurerm_resource_group.rgname.name
}

output "project_name" {
  value = var.project_name
}

output "storage_account_name" {
  value = azurerm_storage_account.str-acct.name
}

output "storage_container_name" {
  value = azurerm_storage_container.str-container.name
}

output "key_vault_name" {
  value = azurerm_key_vault.keyvault.name
}

output "sshkey_name" {
  value = azurerm_ssh_public_key.aks_ssh_key.name
}