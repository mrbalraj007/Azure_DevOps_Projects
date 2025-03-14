resource "azuredevops_workitem" "backlog_item1" {
  project_id     = azuredevops_project.project.id
  type           = "Bug"
  title          = "Backlog Item 1"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "backlog_item2" {
  project_id     = azuredevops_project.project.id
  type           = "Bug"
  title          = "Backlog Item 2"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "backlog_item3" {
  project_id     = azuredevops_project.project.id
  type           = "Bug"
  title          = "Backlog Item 3"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}
