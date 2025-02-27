resource "azuredevops_serviceendpoint_aws" "aws_connection" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = var.aws_service_connection_name
  description           = "AWS service connection Managed by AzureDevOps"

  access_key_id     = var.aws_access_key_id
  secret_access_key = var.aws_secret_access_key
}

resource "azuredevops_pipeline_authorization" "aws_connection_auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_aws.aws_connection.id
  type        = "endpoint"
}
