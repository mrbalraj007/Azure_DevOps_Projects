resource_group_name = "rg-ad-server"
location            = "eastus"
vnet_name           = "ad-vnet"
subnet_name         = "ad-subnet"
admin_username      = "adminuser"
admin_password      = "SecureP@ssw0rd123!"
domain_name         = "singh.org.au"
ou_name             = "SINGH-Integration"
users               = ["AWS-User-Admin", "AWS-User-CLI", "AWS-User-IAM", "AWS-User-Others"]
groups              = ["SINGH_Admin-Role", "SINGH_CLI-Role", "SINGH_IAM-Role", "SINGH_Others-Role"]
