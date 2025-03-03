# List of Virtual Network Names
vnet1_name = "az700-rg01-vnet-01"
# vnet2_name = "az700-rg02-vnet-01"
# vnet3_name = "az700-rg03-vnet-01"

# List of Resource Group Names
rg_name_1 = "az700-rg01"
# rg_name_2 = "az700-rg02"
# rg_name_3 = "az700-rg03"



# List of Virtual Network Gateway 
gateway_location       = "eastus"
az700-rg1-gateway-pip  = "az700-rg1-gateway-01-pip"
gateway-subnet-name    = "GatewaySubnet" #"rg1-GatewaySubnet"
az700-rg1-gateway-name = "az700-rg1-gateway-01"
allocation_method      = "Static"
sku                    = "Standard"


# List of local network Gateway
lng_name                 = "localNetworkGWTest"
local_pc-gateway_address = "61.69.158.197" # define public IP address
local_pc-address_space   = ["192.168.1.0/24"]


# List of Virtual Network Gateway Connection
site_to_site_connection_name = "site-to-site-connection"
shared_key                   = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"