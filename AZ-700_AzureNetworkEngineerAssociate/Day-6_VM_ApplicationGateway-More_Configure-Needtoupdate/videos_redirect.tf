# Create a dedicated public IP for videos access
resource "azurerm_public_ip" "videos_ip" {
  name                = "videos-direct-ip"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create a traffic manager profile to redirect traffic
resource "azurerm_traffic_manager_profile" "videos_traffic" {
  name                   = "videos-traffic-manager"
  resource_group_name    = azurerm_resource_group.rg01.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "az700videos"
    ttl           = 30
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/videos/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }
}

# Add the backend endpoint for direct VM access - use the correct resource type
resource "azurerm_traffic_manager_external_endpoint" "videos_endpoint" {
  name                   = "videos-direct-endpoint"
  profile_id             = azurerm_traffic_manager_profile.videos_traffic.id
  target                 = azurerm_public_ip.rg01_public_ip2-eastus.ip_address
  endpoint_location      = azurerm_resource_group.rg01.location
  priority               = 1
}

# Output the Traffic Manager URL
output "videos_traffic_manager_url" {
  value = "http://${azurerm_traffic_manager_profile.videos_traffic.fqdn}/videos/"
}

# Create a convenient redirect HTML page
resource "local_file" "videos_redirect_html" {
  filename = "${path.module}/videos-redirect.html"
  content  = <<-EOT
    <!DOCTYPE html>
    <html>
    <head>
      <title>Videos Redirect</title>
      <meta http-equiv="refresh" content="0;URL='http://${azurerm_public_ip.rg01_public_ip2-eastus.ip_address}/videos/'" />
    </head>
    <body>
      <h1>Redirecting to Videos...</h1>
      <p>If you are not redirected automatically, click <a href="http://${azurerm_public_ip.rg01_public_ip2-eastus.ip_address}/videos/">here</a>.</p>
    </body>
    </html>
  EOT
}
