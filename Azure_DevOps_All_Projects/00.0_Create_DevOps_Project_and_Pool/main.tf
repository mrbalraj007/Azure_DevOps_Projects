resource "azuredevops_project" "project" {
  name       = var.project_name
  visibility = "private"
}

resource "azuredevops_agent_pool" "pool" {
  name = var.agent_pool_name
}
