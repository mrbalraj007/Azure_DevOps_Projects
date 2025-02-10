output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "webapp_name" {
  value = azurerm_linux_web_app.app.name
}

output "project_name" {
  value = var.project_name
}

output "artifact_feed_name" {
  value = azuredevops_feed.feed.name
}