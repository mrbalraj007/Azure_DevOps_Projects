resource "azuredevops_workitem" "board_task" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Project Board Task"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}
