resource "azuredevops_workitem" "epic" {
  project_id     = azuredevops_project.project.id
  type           = "Epic"
  title          = "Online Payment System Implement Epic"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}


resource "azuredevops_workitem" "feature" {
  project_id     = azuredevops_project.project.id
  type           = "Feature"
  title          = "Feature Working item 01.1"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
  # Note: Linking work items is not supported directly in Terraform.
  # After applying, manually link this feature to the epic "Implement Online Payment System" in Azure DevOps UI.
}

# Note: Work item links (like linking user stories to epics) cannot be created directly via Terraform.
# After applying this configuration, you'll need to manually establish the links in the Azure DevOps UI:
# 1. Navigate to the epic "Implement Online Payment System"
# 2. Under "Related Work", add links to the user stories and features
# 3. Set the link type to "Child" for proper hierarchy

