resource "azurerm_public_ip" "app_gateway_public_ip" {
  name                = var.app_gateway_public_ip_name
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Add a data source to reference the existing subnet
data "azurerm_subnet" "public" {
  name                 = "AppGateway-Subnet"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name  = azurerm_resource_group.rg01.name
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = var.app_gateway_name
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  sku {
    name     = var.app_gateway_sku_name
    tier     = var.app_gateway_sku_tier
    capacity = var.app_gateway_capacity
  }

  gateway_ip_configuration {
    name      = "${var.app_gateway_name}-ip-config"
    subnet_id = data.azurerm_subnet.public.id
  }

  frontend_ip_configuration {
    name                 = "${var.app_gateway_name}-frontend-ip"
    public_ip_address_id = azurerm_public_ip.app_gateway_public_ip.id
  }

  frontend_port {
    name = "frontend-port"
    port = var.app_gateway_frontend_port
  }

  # First backend pool for images served by VM01
  backend_address_pool {
    name = "image"
    ip_addresses = [
      azurerm_network_interface.rg01_nic1-eastus.private_ip_address
    ]
  }

  # Second backend pool for videos served by VM02
  backend_address_pool {
    name = "video"
    ip_addresses = [
      azurerm_network_interface.rg01_nic2-eastus.private_ip_address
    ]
  }

  backend_http_settings {
    name                  = "backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = var.app_gateway_backend_port
    protocol              = "Http"
    request_timeout       = var.app_gateway_request_timeout
  }

  http_listener {
    name                           = "image-listener"
    frontend_ip_configuration_name = "${var.app_gateway_name}-frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
    host_name                      = "images.example.com"
  }

  http_listener {
    name                           = "video-listener"
    frontend_ip_configuration_name = "${var.app_gateway_name}-frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
    host_name                      = "videos.example.com"
  }

  # Default listener for traffic not matching other patterns
  http_listener {
    name                           = "default-listener"
    frontend_ip_configuration_name = "${var.app_gateway_name}-frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }

  # Add a dedicated listener for path-based routing
  http_listener {
    name                           = "path-based-listener"
    frontend_ip_configuration_name = "${var.app_gateway_name}-frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
    host_name                      = "content.example.com"
  }

  # URL path map for path-based routing - this handles all traffic
  url_path_map {
    name                               = "main-routing"
    default_backend_address_pool_name  = "image"
    default_backend_http_settings_name = "backend-http-settings"

    path_rule {
      name                       = "images-path-rule"
      paths                      = ["/images/*"]
      backend_address_pool_name  = "image"
      backend_http_settings_name = "backend-http-settings"
    }

    path_rule {
      name                       = "videos-path-rule"
      paths                      = ["/videos/*"]
      backend_address_pool_name  = "video"
      backend_http_settings_name = "backend-http-settings"
    }
  }

  # Single path-based routing rule that handles all traffic
  request_routing_rule {
    name               = "main-rule"
    priority           = 100
    rule_type          = "PathBasedRouting"
    http_listener_name = "default-listener"
    url_path_map_name  = "main-routing"
  }

  # Keep host-based routing for specific domains
  request_routing_rule {
    name                       = "image-rule"
    priority                   = 110
    rule_type                  = "Basic"
    http_listener_name         = "image-listener"
    backend_address_pool_name  = "image"
    backend_http_settings_name = "backend-http-settings"
  }

  request_routing_rule {
    name                       = "video-rule"
    priority                   = 120
    rule_type                  = "Basic"
    http_listener_name         = "video-listener"
    backend_address_pool_name  = "video"
    backend_http_settings_name = "backend-http-settings"
  }

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_windows_virtual_machine.rg01_vm1-eastus,
    azurerm_windows_virtual_machine.rg01_vm2-eastus
  ]
}
