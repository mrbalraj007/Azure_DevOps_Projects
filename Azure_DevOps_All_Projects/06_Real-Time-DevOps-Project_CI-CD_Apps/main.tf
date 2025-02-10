resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.resource_group_name}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.app_service_plan_sku
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.webapp_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  https_only = true
}

# # Check if the custom hostname binding exists

# data "azurerm_app_service_custom_hostname_binding" "existing" {
#   hostname            = "${var.webapp_name}.azurewebsites.net"
#   app_service_name    = azurerm_linux_web_app.app.name
#   resource_group_name = azurerm_resource_group.rg.name
# }

# # Creating a custom hostname binding if it does not exist

# resource "azurerm_app_service_custom_hostname_binding" "hostname_binding" {
#   count               = data.azurerm_app_service_custom_hostname_binding.existing.id == "" ? 1 : 0
#   hostname            = "${var.webapp_name}.azurewebsites.net"
#   app_service_name    = azurerm_linux_web_app.app.name
#   resource_group_name = azurerm_resource_group.rg.name
# }
