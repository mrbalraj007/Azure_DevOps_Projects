resource_group_name_01 = "az700-rg001"
# resource_group_name_02 = "az700-rg02"
# resource_group_name_03 = "az700-rg03"
location_01 = "eastus" # West US 2 , Australia East "Central India" "eastus"
#location_02            = "eastus" # West US 2 , Australia East "Central India" "eastus"
#location_03 = "westus" # West US 2 , Australia East "Central India" "eastus"
# ***********************************************Azure Cloud VM UI Data***********************************************

size           = "Standard_B2s" # Standard_F2, Standard_B2s, Standard_D2s_v3, Standard_DS2_v2, Standard_A2_V2, Standard_B2ms, Standard_D2d_v4, Standard_B1s
admin_username = "adminuser"
admin_password = "P@$$w0rd1234!"
agent_vm_name  = "win-vm"



// Virtual machine configuration
name_rg01_public-eastus = "az700-rg01-public-eastus-vnet-01"
name_rg01_public-westus = "az700-rg01-public-westus-vnet-01"

name_rg01_public_ip1-eastus = "az700-rg01-public-eastus-ip1"
name_rg01_public_ip2-eastus = "az700-rg01-public-eastus-ip2"
name_rg01_public_ip-westus  = "az700-rg01-public-westus-ip1"
name_rg01_nic1-eastus       = "az700-rg01-public-eastus-nic1"
name_rg01_nic2-eastus       = "az700-rg01-public-eastus-nic2"
name_rg01_nic-westus        = "az700-rg01-public-westus-nic1"

name_rg01_vm1-eastus = "az700-rg01-public-eastus-vm01"
name_rg01_vm2-eastus = "az700-rg01-public-eastus-vm02"
name_rg01_vm-westus  = "az700-rg01-public-westus-vm01"
sku                  = "2022-Datacenter"





name_az700-rg01-sg-eastus      = "az700-rg01-sg-eastus"
name_az700-rg01-eastus-vnet-01 = "az700-rg01-eastus-vnet-01"
name_az700-rg01-sg-westus      = "az700-rg01-sg-westus"
name_az700-rg01-westus-vnet-01 = "az700-rg01-westus-vnet-01"



# Application Gateway configuration
app_gateway_name = "app-gateway"
app_gateway_public_ip_name = "app-gateway-public-ip"
app_gateway_sku_name = "Standard_v2"
app_gateway_sku_tier = "Standard_v2"
app_gateway_capacity = 2
app_gateway_frontend_port = 80
app_gateway_backend_port = 80
app_gateway_request_timeout = 20


# ADMIN_PASSWORD = "password@123"
# ADMIN_USERNAME = "azurevm"
# AGENT_VM_NAME  = "agent-vm"
# VM_SIZE        = "Standard_D2s_v3"
# #LOCATION              = "Central India"
# #RESOURCE_GROUP_NAME   = "rg-devops"
# user_data_script_path = "script.sh"

# resource_suffix                     = "devops"
# azurerm_vnet_name                   = "Vnet"
# azurerm_subnet_name                 = "subnet"
# azurerm_public_ip_name              = "publicip"
# azurerm_network_interface_name      = "nic"
# azurerm_network_security_group_name = "nsg"
# azurerm_vm_admin_username           = "azureuser"
# azurerm_vm_size                     = "Standard_B1s" #"Standard_DS2_v2" "Standard_A2_V2" "Standard_B2ms" "Standard_D2d_v4" "Standard_B1s"
# azurerm_computer_name               = "devopsdemovm"
# azurerm_linux_vm_name               = "DevOps_Agent_VM"
# user_data_script_path               = "scripts/user_data_software.sh"