resource "azuredevops_workitem" "sprint1" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "TBD4"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "sprint2" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "TBD5"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "sprint3" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "TBD6"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}
