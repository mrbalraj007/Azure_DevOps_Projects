variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "webapp_name" {
  description = "The name of the Web App"
  type        = string
}

variable "app_service_plan_sku" {
  description = "The SKU of the App Service Plan"
  type        = string
}

variable "user_data_script_path" {
  description = "The path to the user data script"
  type        = string
}