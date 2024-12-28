variable "location" {

}
 variable "resource_group_name" {}

variable "service_principal_name" {
  type = string
}

variable "ssh_public_key" {
  description = "Path to the SSH public key"
  type        = string
  default = "./modules/aks/id_ed25519.pub"
}

variable "client_id" {}
variable "client_secret" {
  type = string
  sensitive = true
}