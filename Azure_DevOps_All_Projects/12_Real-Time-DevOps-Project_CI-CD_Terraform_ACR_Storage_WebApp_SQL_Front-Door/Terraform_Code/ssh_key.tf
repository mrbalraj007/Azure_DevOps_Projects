resource "azurerm_ssh_public_key" "aks_ssh_key" {
  name                = "aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  public_key          = tls_private_key.ssh_key.public_key_openssh
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
