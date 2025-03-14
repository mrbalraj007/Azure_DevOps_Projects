resource "azuredevops_workitem" "workitem" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Design database schema for payment information"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem1" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Implement payment gateway integration."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem2" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Develop front-end form for payment information."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem3" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Encrypt payment information before storing it in the database"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem4" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Design order summary page layout"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}


resource "azuredevops_workitem" "workitem5" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Implement backend logic to fetch order details."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem6" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Develop frontend to display order summary."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem7" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Add functionality to modify the order before payment"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem8" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Add functionality to modify the order before payment"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem9" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Design email template for order confirmation."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem10" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Implement email service to send order confirmations."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem11" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "Test email delivery and content accuracy.."
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem12" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "TBD"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem13" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "TBD1"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}

resource "azuredevops_workitem" "workitem14" {
  project_id     = azuredevops_project.project.id
  type           = "Task"
  title          = "TBD2"
  area_path      = azuredevops_project.project.name
  iteration_path = "${azuredevops_project.project.name}\\Iteration 1"
}
