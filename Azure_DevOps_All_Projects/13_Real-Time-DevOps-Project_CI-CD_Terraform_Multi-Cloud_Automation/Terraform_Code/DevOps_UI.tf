resource "azuredevops_project" "project" {
  name               = var.project_name
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
  description        = "Managed by Terraform"
}

# resource "azuredevops_agent_pool" "pool" {
#   name = var.agent_pool_name
# }

resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.project.id
  name       = var.repository_name
  initialization {
    init_type   = "Import"
    source_url  = var.source_url
    source_type = "Git"
  }
}
