output "service_principal_name" {
  description = "This object id is used to assign the owner role to the service principal"
  value       = azuread_service_principal.main.display_name
}

output "service_principal_object_id" {
  description = "This object id is used to assign the owner role to the service principal"
  value       = azuread_service_principal.main.object_id
}

output "service_principal_tenant_id" {
  description = "This object id is used to assign the owner role to the service principal"
  value       = data.azuread_client_config.current.tenant_id
}

output "client_id" {
  description = "This object id is used to assign the owner role to the service principal"
  value       = azuread_service_principal.main.client_id
}

output "client_secret" {
  description = "This object id is used to assign the owner role to the service principal"
  value       = azuread_service_principal_password.main.value
}