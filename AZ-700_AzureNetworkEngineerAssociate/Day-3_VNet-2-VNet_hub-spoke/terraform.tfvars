
# List of Virtual Network Names
vnet1_name = "az700-rg01-vnet-01"
# vnet2_name = "az700-rg02-vnet-01"
vnet3_name = "az700-rg03-vnet-01"

# List of Resource Group Names
rg_name_1 = "az700-rg01"
# rg_name_2 = "az700-rg02"
rg_name_3 = "az700-rg03"

# vnet1-to-vnet2-peering-name = "vnet1-to-vnet2"
# vnet2-to-vnet1-peering-name = "vnet2-to-vnet1"
# vnet1-to-vnet3-peering-name = "vnet1-to-vnet3"
# vnet3-to-vnet1-peering-name = "vnet3-to-vnet1"

# List of Virtual Network Gateway Locations
allocation_method = "Static"
sku               = "Standard"



gateway_location       = "eastus"
az700-rg1-gateway-pip  = "az700-rg1-gateway-01-pip"
gateway-subnet-name    = "GatewaySubnet" #"rg1-GatewaySubnet"
az700-rg1-gateway-name = "az700-rg1-gateway-01"



gateway_location1     = "westus"
az700-rg3-gateway-pip = "az700-rg3-gateway-01-pip"
#az700-rg3-GatewaySubnet = "GatewaySubnet" #"rg2-GatewaySubnet"
az700-rg3-gateway-name = "az700-rg3-gateway-01"



# List of Virtual Network Gateway Connections

vnet1-to-vnet3-connection-name = "vnet1-to-vnet3-connection"
vnet3-to-vnet1-connection-name = "vnet3-to-vnet1-connection"
connection_type                 = "Vnet2Vnet"
connection_protocol            = "IKEv2"
shared_key                     = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"


# resource_group_name_01 = "az700-rg01"
# resource_group_name_02 = "az700-rg02"
# resource_group_name_03 = "az700-rg03"
# location_01            = "eastus" # West US 2 , Australia East "Central India" "eastus"
# location_02            = "eastus" # West US 2 , Australia East "Central India" "eastus"
# location_03            = "westus" # West US 2 , Australia East "Central India" "eastus"
# # ***********************************************Azure Cloud VM UI Data***********************************************

# size           = "Standard_F2"
# admin_username = "adminuser"
# admin_password = "P@$$w0rd1234!"
# agent_vm_name  = "win-vm"

# # ADMIN_PASSWORD = "password@123"
# # ADMIN_USERNAME = "azurevm"
# # AGENT_VM_NAME  = "agent-vm"
# # VM_SIZE        = "Standard_D2s_v3"
# # #LOCATION              = "Central India"
# # #RESOURCE_GROUP_NAME   = "rg-devops"
# # user_data_script_path = "script.sh"

# # resource_suffix                     = "devops"
# # azurerm_vnet_name                   = "Vnet"
# # azurerm_subnet_name                 = "subnet"
# # azurerm_public_ip_name              = "publicip"
# # azurerm_network_interface_name      = "nic"
# # azurerm_network_security_group_name = "nsg"
# # azurerm_vm_admin_username           = "azureuser"
# # azurerm_vm_size                     = "Standard_B1s" #"Standard_DS2_v2" "Standard_A2_V2" "Standard_B2ms" "Standard_D2d_v4" "Standard_B1s"
# # azurerm_computer_name               = "devopsdemovm"
# # azurerm_linux_vm_name               = "DevOps_Agent_VM"
# # user_data_script_path               = "scripts/user_data_software.sh"