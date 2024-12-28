resource "azurerm_resource_group" "rg1" {
  name     = var.regname
  location = var.location
}

module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [azurerm_resource_group.rg1]
}

resource "azurerm_role_assignment" "rolespn" {
  scope                = "/subscriptions/2fc598a4-6a52-44b9-b476-6a62640513f8"
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [module.ServicePrincipal]
}

module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  recover_group_name          = var.regname
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id
}

resource "azurerm_role_assignment" "keyvault_access" {
  scope                = module.keyvault.key_vault_id
  role_definition_name = "Key Vault Administrator" # Key Vault Secrets User
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [module.keyvault]
}

resource "time_sleep" "wait_for_role" {
  create_duration = "60s" # Adjust the duration if needed

  depends_on = [azurerm_role_assignment.keyvault_access]
}

resource "azurerm_key_vault_secret" "example" {
  name         = module.ServicePrincipal.client_id
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.keyvault.key_vault_id

  depends_on = [
    time_sleep.wait_for_role
  ]
}

module "aks" {
  source                 = "./modules/aks"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.location
  resource_group_name    = var.regname
}