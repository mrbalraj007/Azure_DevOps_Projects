provider "azurerm" {
  features {}
}

variable "resource_group_name" {}
variable "location" {}
variable "vnet_name" {}
variable "subnet_name" {}
variable "admin_username" {}
variable "admin_password" {}
variable "domain_name" {}
variable "ou_name" {}
variable "users" {
  type = list(string)
}
variable "groups" {
  type = list(string)
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "ad-vm-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "ad-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-AD-Ports"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["53", "88", "135", "389", "445", "464", "636", "3268", "3269"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "ad-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "ad-server"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Upload the AD installation script to blob storage
resource "azurerm_storage_account" "scripts" {
  name                     = "adscripts${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_id    = azurerm_storage_account.scripts.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "ad_script" {
  name                   = "Install-AD.ps1"
  storage_account_name   = azurerm_storage_account.scripts.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "Install-AD.ps1"
}

# Upload the user and group creation script with the correct name
resource "azurerm_storage_blob" "user_group_script" {
  name                   = "user_group.ps1"
  storage_account_name   = azurerm_storage_account.scripts.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "Configure-AD-Users-and-Groups.ps1" # Updated to correct file path
  

}

# Create SAS token for script access
data "azurerm_storage_account_sas" "scripts_sas" {
  connection_string = azurerm_storage_account.scripts.primary_connection_string
  https_only        = true

  resource_types {
    service   = false
    container = false
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "2h")

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}

# Use Custom Script Extension to configure and install AD
resource "azurerm_virtual_machine_extension" "install_ad" {
  name                       = "install-ad"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "fileUris": [
        "${azurerm_storage_blob.ad_script.url}${data.azurerm_storage_account_sas.scripts_sas.sas}",
        "${azurerm_storage_blob.user_group_script.url}${data.azurerm_storage_account_sas.scripts_sas.sas}"
      ],
      "commandToExecute": "powershell.exe -ExecutionPolicy Bypass -Command \"Copy-Item -Path Install-AD.ps1 -Destination C:\\ -Force; Copy-Item -Path user_group.ps1 -Destination C:\\ -Force; powershell.exe -ExecutionPolicy Bypass -File C:\\Install-AD.ps1 -DomainName ${var.domain_name} -OUName ${var.ou_name} -Users '${join(",", var.users)}' -Groups '${join(",", var.groups)}'\""
    }
  SETTINGS

  depends_on = [
    azurerm_storage_blob.ad_script,
    azurerm_storage_blob.user_group_script
  ]

  timeouts {
    create = "90m" # Extended timeout to allow for AD installation, reboot, and user setup
  }
}

output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
