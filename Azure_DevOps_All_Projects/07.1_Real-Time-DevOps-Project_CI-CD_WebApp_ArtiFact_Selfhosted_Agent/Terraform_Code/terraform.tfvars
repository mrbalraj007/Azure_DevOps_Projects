# Azure DevOps UI Data
azure_devops_organization = "Define Here Organization Name"
azure_devops_pat = "Define Here DevOps PAT Token"

project_name    = "Project_Nike-WebSite"
agent_pool_name = "nike-website-pool"


source_url      = "https://github.com/piyushsachdeva/nike_landing_page.git" # Define the Git URL here
repository_name = "Nike-Website"                                            # Ensure this is consistent

artifact_feed_name = "Nike-WebSite-UniqueFeed" # Updated the Artifact Feed Name to a unique value    

# Azure Portal UI Data

resource_group_name   = "myfirst-demo-09012025-rg"
location              = "Australia East"
webapp_name           = "myfirst-demo-webapp"
app_service_plan_sku  = "P0v3"
user_data_script_path = "scripts/user_data_software.sh"
#expected sku_name to be one of ["B1" "B2" "B3" "S1" "S2" "S3" "P1v2" "P2v2" "P3v2" "P0v3" "P1v3" "P2v3" "P3v3" "P1mv3" "P2mv3" "P3mv3" "P4mv3" "P5mv3" "Y1" "EP1" "EP2" "EP3" "FC1" "F1" "I1" "I2" "I3" "I1v2" "I2v2" "I3v2" "I4v2" "I5v2" "I6v2" "D1" "SHARED" "WS1" "WS2" "WS3"],

resource_suffix = "First-Demo" # Change here the value. This will be used to create unique names for resources

azurerm_vnet_name                   = "Vnet"
azurerm_subnet_name                 = "subnet"
azurerm_public_ip_name              = "publicip"
azurerm_network_interface_name      = "nic"
azurerm_network_security_group_name = "nsg"
azurerm_vm_admin_username           = "azureuser"
azurerm_vm_size                     = "Standard_DS2_v2" #"Standard_DS2_v2" "Standard_A2_V2" "Standard_B2ms" "Standard_D2d_v4"
azurerm_computer_name               = "devopsdemovm"
azurerm_linux_vm_name               = "DevOps_Agent_VM"