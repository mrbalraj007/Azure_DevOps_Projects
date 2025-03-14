resource "azuredevops_workitem" "issue" {
  project_id     = azuredevops_project.project.id
  type           = "Issue"
  title          = "Critical Issue: Performance Degradation"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "bug" {
  project_id     = azuredevops_project.project.id
  type           = "Bug"
  title          = "Bug: Application Crashes on Login"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}
