resource "azuredevops_serviceendpoint_azurerm" "azure_rm_connection" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = var.azure_rm_service_connection_name
  description           = "Azure Resource Manager service connection Managed by AzureDevOps"
  credentials {
    serviceprincipalid  = var.azure_client_id
    serviceprincipalkey = var.azure_client_secret
  }
  azurerm_spn_tenantid      = var.azure_tenant_id
  azurerm_subscription_id   = var.azure_subscription_id
  azurerm_subscription_name = var.azure_subscription_name

  service_endpoint_authentication_scheme = "ServicePrincipal"
}

resource "azuredevops_pipeline_authorization" "azure_rm_connection_auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.azure_rm_connection.id
  type        = "endpoint"
}
