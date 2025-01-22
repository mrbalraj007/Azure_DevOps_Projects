# Azure DevOps UI Data
azure_devops_organization = "Define Here Organization Name"
azure_devops_pat = "Define Here DevOps PAT Token"

project_name              = "Python-app-docker"
agent_pool_name           = "Terraform-Agent-pool"

source_url      = "https://github.com/mrbalraj007/python-app-docker.git" # Define the Git URL here
repository_name = "Python-app-docker"                                    # Ensure this is consistent


azurerm_sp_client_id_value     = "Update value here"
azurerm_sp_client_secret_value = "Update value here"
azurerm_sp_tenant_value        = "Update value here"
azurerm_sp_subs_value          = "Update value here"
azurerm_sp_email               = "Update value here"

resource_suffix = "Project" # Change here the value. This will be used to create unique names for resources

# Azure Portal UI Data

resource_group_name   = "rg-22012025"
location              = "West US 2" # West US 2 , Australia East
user_data_script_path = "scripts/user_data_software.sh"

azurerm_vnet_name                   = "Vnet"
azurerm_subnet_name                 = "subnet"
azurerm_public_ip_name              = "publicip"
azurerm_network_interface_name      = "nic"
azurerm_network_security_group_name = "nsg"
azurerm_vm_admin_username           = "azureuser"
azurerm_vm_size                     = "Standard_DS2_v2"
azurerm_computer_name               = "devopsdemovm"
azurerm_linux_vm_name               = "DevOps_Agent_VM"
