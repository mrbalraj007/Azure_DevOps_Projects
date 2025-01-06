# Preferred Low-Cost Regions: Historically, some regions are known for lower pricing:
# US Regions: East US, West US
# Asia-Pacific Regions: Southeast Asia, Central India
# Europe: North Europe, West Europe

user_data_script_path = "scripts/user_data_software.sh"

resource_group_name = "aks_terraform_rg"
location            = "West US 2"
cluster_name        = "terraform-aks"
kubernetes_version  = "1.31.2" # 1.30.6
system_node_count   = 1
node_resource_group = "aks_terraform_resources_rg"