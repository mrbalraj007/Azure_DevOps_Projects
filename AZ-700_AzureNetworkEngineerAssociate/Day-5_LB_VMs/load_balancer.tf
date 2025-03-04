// Create a dedicated public IP for the load balancer
resource "azurerm_public_ip" "rg01_lb_public_ip" {
  name                = "az700-rg01-lb-public-ip"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"   // Load balancers require static IPs
  sku                 = "Standard" // Must match the LB SKU
  depends_on          = [azurerm_virtual_network.vnet1]
}

resource "azurerm_lb" "rg01_lb" {
  name                = var.name_az700-rg01-lb
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.rg01_lb_public_ip.id // Use the dedicated public IP
  }

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_windows_virtual_machine.rg01_vm1-eastus,
    azurerm_windows_virtual_machine.rg01_vm2-eastus
  ]
}

resource "azurerm_lb_backend_address_pool" "rg01_lb_backend" {
  name            = var.name_rg01-lb-backend
  loadbalancer_id = azurerm_lb.rg01_lb.id
}

resource "azurerm_lb_probe" "rg01_lb_probe" {
  name                = var.name_http_probe
  loadbalancer_id     = azurerm_lb.rg01_lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "rg01_lb_rule" {
  name                           = var.name_http_rule
  loadbalancer_id                = azurerm_lb.rg01_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.rg01_lb_backend.id]
  probe_id                       = azurerm_lb_probe.rg01_lb_probe.id
}

resource "azurerm_network_interface_backend_address_pool_association" "rg01_nic1_backend_association" {
  network_interface_id    = azurerm_network_interface.rg01_nic1-eastus.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.rg01_lb_backend.id
}

resource "azurerm_network_interface_backend_address_pool_association" "rg01_nic2_backend_association" {
  network_interface_id    = azurerm_network_interface.rg01_nic2-eastus.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.rg01_lb_backend.id
}
