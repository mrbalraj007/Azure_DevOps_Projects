resource "azuredevops_feed" "feed" {
  project_id = azuredevops_project.project.id
  name       = var.artifact_feed_name # Ensure this matches the updated artifact_feed_name
  #description      = "Feed for storing artifacts"
  #upstream_enabled = false
}
