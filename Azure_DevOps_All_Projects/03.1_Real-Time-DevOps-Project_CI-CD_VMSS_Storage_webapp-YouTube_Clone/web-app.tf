resource "azurerm_service_plan" "asp" {
  name                = "${var.resource_group_name}-asp"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name            = var.app_service_plan_sku
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.webapp_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
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

// ...existing code...
