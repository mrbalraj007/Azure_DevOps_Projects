module "rg" {
  source               = "./vm_module"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.subnet_name
  public_ip_name       = var.public_ip_name
  virtual_machine_name = var.virtual_machine_name
  location             = var.location
}