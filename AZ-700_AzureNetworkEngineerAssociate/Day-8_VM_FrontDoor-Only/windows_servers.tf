// Public IPs
resource "azurerm_public_ip" "rg01_public_ip-centralindia" {
  name                = var.name_rg01_public_ip-centralindia
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.dns_label_prefix_centralindia}-${random_string.dns_prefix.result}"
  depends_on          = [azurerm_virtual_network.vnet1]
}

resource "azurerm_public_ip" "rg01_public_ip-eastus" {
  name                = var.name_rg01_public_ip-eastus
  location            = var.location_02
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.dns_label_prefix_eastus}-${random_string.dns_prefix.result}"
  depends_on          = [azurerm_virtual_network.vnet2]
}

// Add random string resource for unique DNS names
resource "random_string" "dns_prefix" {
  length  = 6
  special = false
  upper   = false
}

// Network Interfaces
resource "azurerm_network_interface" "rg01_nic-centralindia" {
  name                = var.name_rg01_nic-centralindia
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.vnet1.id}/subnets/${var.centralindia_public_subnet_name}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg01_public_ip-centralindia.id
  }
  accelerated_networking_enabled = false
  depends_on                     = [azurerm_virtual_network.vnet1]
}

resource "azurerm_network_interface" "rg01_nic-eastus" {
  name                = var.name_rg01_nic-eastus
  location            = var.location_02
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.vnet2.id}/subnets/${var.eastus_public_subnet_name}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg01_public_ip-eastus.id
  }
  accelerated_networking_enabled = false
  depends_on                     = [azurerm_virtual_network.vnet2]
}

resource "azurerm_network_interface_security_group_association" "nsg_association_centralindia" {
  network_interface_id      = azurerm_network_interface.rg01_nic-centralindia.id
  network_security_group_id = azurerm_network_security_group.rg01-sg-centralindia.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association_eastus" {
  network_interface_id      = azurerm_network_interface.rg01_nic-eastus.id
  network_security_group_id = azurerm_network_security_group.rg01-sg-eastus.id
}

// Windows VMs
resource "azurerm_windows_virtual_machine" "rg01_vm-centralindia" {
  name                = var.name_rg01_vm-centralindia
  resource_group_name = azurerm_resource_group.rg01.name
  location            = var.location_01
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = "${var.agent_vm_name}-centralindia"
  network_interface_ids = [
    azurerm_network_interface.rg01_nic-centralindia.id,
  ]

  availability_set_id = null

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_storage_account_type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.sku
    version   = "latest"
  }

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_network_security_group.rg01-sg-centralindia,
    azurerm_network_interface.rg01_nic-centralindia
  ]
}

resource "azurerm_windows_virtual_machine" "rg01_vm-eastus" {
  name                = var.name_rg01_vm-eastus
  resource_group_name = azurerm_resource_group.rg01.name
  location            = var.location_02
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = "${var.agent_vm_name}-eastus"
  network_interface_ids = [
    azurerm_network_interface.rg01_nic-eastus.id,
  ]

  availability_set_id = null

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_storage_account_type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.sku
    version   = "latest"
  }

  depends_on = [
    azurerm_virtual_network.vnet2,
    azurerm_network_security_group.rg01-sg-eastus,
    azurerm_network_interface.rg01_nic-eastus
  ]
}

resource "azurerm_virtual_machine_extension" "rg01_vm_centralindia_extension" {
  name                 = var.vm_centralindia_extension_name
  virtual_machine_id   = azurerm_windows_virtual_machine.rg01_vm-centralindia.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -Command \"netsh advfirewall set allprofiles state off; Install-WindowsFeature -name Web-Server -IncludeManagementTools; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '<html><body><h1>This is the Central India server</h1></body></html>'\""
  })
}

resource "azurerm_virtual_machine_extension" "rg01_vm_eastus_extension" {
  name                 = var.vm_eastus_extension_name
  virtual_machine_id   = azurerm_windows_virtual_machine.rg01_vm-eastus.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -Command \"netsh advfirewall set allprofiles state off; Install-WindowsFeature -name Web-Server -IncludeManagementTools; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '<html><body><h1>This is the East US server</h1></body></html>'\""
  })
}
