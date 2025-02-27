# ***********************************************Azure DevOps UI Data***********************************************
azure_devops_organization = "xxxxxx" # Define the Azure DevOps organization here
azure_devops_pat          = "xxxxxx" # Define the Azure DevOps PAT here

project_name = "Multi-Cloud_Automation" # Define the project name here
#agent_pool_name = "Terraform-Agent-pool"

source_url      = "https://github.com/mrbalraj007/multi-cloud-project.git" # Define the Git URL here
repository_name = "Repo_Automation_MultiCloud"                             # Ensure this is consistent

# ***********************************************azure cloud values***********************************************

# ***********************************************Service connection detail for Azure Pipeline***********************************************
# azure_rm_service_connection_name = "AzureRMServiceConnection"
# azure_subscription_id            = "your-subscription-id"
# azure_subscription_name          = "your-subscription-name"
# azure_client_id                  = "your-client-id"
# azure_client_secret              = "your-client-secret"
# azure_tenant_id                  = "your-tenant-id"

azure_rm_service_connection_name = "Azure-Service-Connection"                 # "AzureRMServiceConnection"
azure_subscription_id            = "xxxxxx"     #"your-subscription-id"
azure_subscription_name          = "DevOpsLearning"                           #"your-subscription-name"
azure_client_id                  = "xxxxxx"     #"your-client-id"
azure_client_secret              = "xxxxxx" #"your-client-secret"
azure_tenant_id                  = "xxxxxx"     #"your-tenant-id"


# ***********************************************AWS cloud values***********************************************
azure_rm_service_connection_name_aws = "AWS-service-connection"
aws_access_key_id                    = "xxxxxx"                     # define the AWS access key
aws_secret_access_key                = "xxxxxx" # define the AWS secret key
aws_service_connection_name          = "AWS-service-connection"
aws_region                           = "us-east-1" # define the AWS region


# ***********************************************Azure Cloud VM UI Data***********************************************

resource_group_name = "multicloud-rg"
location            = "Central India" # West US 2 , Australia East "Central India" "eastus"
# ***********************************************Azure Cloud VM UI Data***********************************************
# ADMIN_PASSWORD = "password@123"
# ADMIN_USERNAME = "azurevm"
# AGENT_VM_NAME  = "agent-vm"
# VM_SIZE        = "Standard_D2s_v3"
# #LOCATION              = "Central India"
# #RESOURCE_GROUP_NAME   = "rg-devops"
# user_data_script_path = "script.sh"

resource_suffix                     = "devops"
azurerm_vnet_name                   = "Vnet"
azurerm_subnet_name                 = "subnet"
azurerm_public_ip_name              = "publicip"
azurerm_network_interface_name      = "nic"
azurerm_network_security_group_name = "nsg"
azurerm_vm_admin_username           = "azureuser"
azurerm_vm_size                     = "Standard_B1s" #"Standard_DS2_v2" "Standard_A2_V2" "Standard_B2ms" "Standard_D2d_v4" "Standard_B1s"
azurerm_computer_name               = "devopsdemovm"
azurerm_linux_vm_name               = "DevOps_Agent_VM"
user_data_script_path               = "scripts/user_data_software.sh"