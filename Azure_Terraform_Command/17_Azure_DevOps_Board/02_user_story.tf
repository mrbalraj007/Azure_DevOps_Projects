resource "azuredevops_workitem" "user_story" {
  project_id     = azuredevops_project.project.id
  type           = "User Story"
  title          = "As a customer, I want to securely add my payment information."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
  # Note: Linking work items (like linking this user story to an epic) is not supported directly in Terraform.
  # After applying, manually link this user story to the epic "Implement Online Payment System" in Azure DevOps UI.
}

resource "azuredevops_workitem" "user_story1" {
  project_id     = azuredevops_project.project.id
  type           = "User Story"
  title          = "As a customer, I want to view a summary of my order before completing the purchase."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
  # Note: Linking work items (like linking this user story to an epic) is not supported directly in Terraform.
  # After applying, manually link this user story to the epic "Implement Online Payment System" in Azure DevOps UI.
}

resource "azuredevops_workitem" "user_story2" {
  project_id     = azuredevops_project.project.id
  type           = "User Story"
  title          = "As a customer, I want to receive an email confirmation after my purchase."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
  # Note: Linking work items (like linking this user story to an epic) is not supported directly in Terraform.
  # After applying, manually link this user story to the epic "Implement Online Payment System" in Azure DevOps UI.
}