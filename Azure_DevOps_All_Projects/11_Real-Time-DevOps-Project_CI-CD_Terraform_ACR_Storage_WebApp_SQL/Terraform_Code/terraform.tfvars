# ***********************************************Azure DevOps UI Data***********************************************
azure_devops_organization = "<Update the Azure DevOps Organization Name>"
azure_devops_pat          = "Update the Azure DevOps PAT Token"

project_name = "e-ticket_application"
#agent_pool_name = "Terraform-Agent-pool"

source_url      = "https://github.com/mrbalraj007/infra-as-code.git" # Define the Git URL here
repository_name = "infra-as-code"                                    # Ensure this is consistent

source_url1      = "https://github.com/mrbalraj007/etickets.git" # Define the Git URL here
repository_name1 = "etickets-main"                               # Ensure this is consistent and unique

# ***********************************************SP details***********************************************
azure_sp_object_id = "xxxxxxxx-118c-4d4c-xxxx-xxxxx" # Replace with actual object ID (When you log in to the Azure portal, make sure to use the Object ID of the email account you used to log in.)

# ***********************************************VNET-Variables detail for Azure Pipeline***********************************************
ACR_ADDRESS_SPACE           = "12.0.0.0/16"
ACR_SUBNET_ADDRESS_PREFIX   = "12.0.0.0/16"
ACR_SUBNET_NAME             = "acr-subnet"
ACR_VNET_NAME               = "acr-vnet"
AGENT_ADDRESS_SPACE         = "13.0.0.0/16"
AGENT_SUBNET_ADDRESS_PREFIX = "13.0.0.0/16"
AGENT_SUBNET_NAME           = "agent-subnet"
AGENT_VNET_NAME             = "agent-vnet"
AKS_ADDRESS_SPACE           = "11.0.0.0/12"
AKS_SUBNET_ADDRESS_PREFIX   = "11.0.0.0/16"
AKS_SUBNET_NAME             = "aks-subnet"
AKS_VNET_NAME               = "aks-vnet"
APPGW_SUBNET_ADDRESS_PREFIX = "11.1.0.0/24"
APPGW_SUBNET_NAME           = "appgw-subnet"


# ***********************************************VM_Variables detail for Azure Pipeline***********************************************
#ADMIN_USERNAME = "azureuser"
ADMIN_USERNAME = "azureuser"
AGENT_VM_NAME  = "agent-vm"
ADMIN_PASSWORD = "password@123"
VM_SIZE        = "Standard_D2s_v3"


# ***********************************************AppGw_Variables detail for Azure Pipeline***********************************************
APP_GATEWAY_NAME     = "ApplicationGateway1"
APPGW_PUBLIC_IP_NAME = "appgwpublicip"
VIRTUAL_NETWORK_NAME = "aks-vnet"

# ***********************************************ACR Variables detail for Azure Pipeline***********************************************
ACR_SKU          = "Premium"
PRIVATE_ACR_NAME = "myacr30012025"



#***********************************************AKS_Variables detail for Azure Pipeline***********************************************
AKS_DNS_PREFIX     = "aksdemo91"
AKS_NAME           = "aksdemo"
AKS_SSH_PUBLIC_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDISouAixKceBD8mM"



# ***********************************************Database Variables detail for Azure Pipeline***********************************************
DB_COLLATION  = "SQL_Latin1_General_CP1_CI_AS"
DB_NAME       = "etickets-db"
DBPASSWORD    = "password@123"
DBSERVER_NAME = "eticketdbserver30012025"
DBUSERNAME    = "azureuser"
VNETRULE      = "sql-vnet-rule"


# ***********************************************Global Variables detail for Azure Pipeline***********************************************
resource_group_name = "rg-devops"
location            = "Central India" # West US 2 , Australia East "Central India"


# ***********************************************Seceret Variables detail for Azure Pipeline***********************************************
SUBSCRIPTION_ID = "Update value here"




# ***********************************************Common variable for Both Azure DevOps and Azure UI Portal***********************************************
resource_suffix = "Project" # Change here the value. This will be used to create unique names for resources



# ***********************************************Key Vault Info***********************************************
key_vault_name      = "vault"
servicePrincipalId  = "myservicePrincipalId"
servicePrincipalKey = "myservicePrincipalKey"
tenantid            = "mytenantid"

