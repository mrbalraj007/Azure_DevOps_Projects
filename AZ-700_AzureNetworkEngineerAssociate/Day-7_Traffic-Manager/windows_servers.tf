// Public IPs
resource "azurerm_public_ip" "rg01_public_ip1-eastus" {
  name                = var.name_rg01_public_ip1-eastus
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.dns_label_prefix_eastus1}-${random_string.dns_prefix.result}"
  depends_on          = [azurerm_virtual_network.vnet1]
}

resource "azurerm_public_ip" "rg01_public_ip2-eastus" {
  name                = var.name_rg01_public_ip2-eastus
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.dns_label_prefix_eastus2}-${random_string.dns_prefix.result}"
  depends_on          = [azurerm_virtual_network.vnet1]
}

resource "azurerm_public_ip" "rg01_public_ip-westus" {
  name                = var.name_rg01_public_ip-westus
  location            = var.location_02
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.dns_label_prefix_westus}-${random_string.dns_prefix.result}"
  depends_on          = [azurerm_virtual_network.vnet2]
}

// Add random string resource for unique DNS names
resource "random_string" "dns_prefix" {
  length  = 6
  special = false
  upper   = false
}

// Network Interfaces
resource "azurerm_network_interface" "rg01_nic1-eastus" {
  name                = var.name_rg01_nic1-eastus
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.vnet1.id}/subnets/${var.eastus_public_subnet_name}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg01_public_ip1-eastus.id
  }
  accelerated_networking_enabled = false
  depends_on                     = [azurerm_virtual_network.vnet1]
}

resource "azurerm_network_interface" "rg01_nic2-eastus" {
  name                = var.name_rg01_nic2-eastus
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.vnet1.id}/subnets/${var.eastus_public_subnet_name}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg01_public_ip2-eastus.id
  }
  accelerated_networking_enabled = false
  depends_on                     = [azurerm_virtual_network.vnet1]
}

resource "azurerm_network_interface" "rg01_nic-westus" {
  name                = var.name_rg01_nic-westus
  location            = var.location_02
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.vnet2.id}/subnets/${var.westus_public_subnet_name}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg01_public_ip-westus.id
  }
  accelerated_networking_enabled = false
  depends_on                     = [azurerm_virtual_network.vnet2]
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.rg01_nic1-eastus.id
  network_security_group_id = azurerm_network_security_group.rg01-sg-eastus.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association1" {
  network_interface_id      = azurerm_network_interface.rg01_nic2-eastus.id
  network_security_group_id = azurerm_network_security_group.rg01-sg-eastus.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association2" {
  network_interface_id      = azurerm_network_interface.rg01_nic-westus.id
  network_security_group_id = azurerm_network_security_group.rg01-sg-westus.id
}

// Windows VMs
resource "azurerm_windows_virtual_machine" "rg01_vm1-eastus" {
  name                = var.name_rg01_vm1-eastus
  resource_group_name = azurerm_resource_group.rg01.name
  location            = var.location_01
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = "${var.agent_vm_name}-1"
  network_interface_ids = [
    azurerm_network_interface.rg01_nic1-eastus.id,
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
    azurerm_network_security_group.rg01-sg-eastus,
    azurerm_network_interface.rg01_nic1-eastus
  ]
}

resource "azurerm_windows_virtual_machine" "rg01_vm2-eastus" {
  name                = var.name_rg01_vm2-eastus
  resource_group_name = azurerm_resource_group.rg01.name
  location            = var.location_01
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = "${var.agent_vm_name}-2"
  network_interface_ids = [
    azurerm_network_interface.rg01_nic2-eastus.id,
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
    azurerm_network_security_group.rg01-sg-eastus
  ]
}

resource "azurerm_windows_virtual_machine" "rg01_vm-westus" {
  name                = var.name_rg01_vm-westus
  resource_group_name = azurerm_resource_group.rg01.name
  location            = var.location_02
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = var.agent_vm_name
  network_interface_ids = [
    azurerm_network_interface.rg01_nic-westus.id,
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
    azurerm_network_security_group.rg01-sg-westus,
    azurerm_network_interface.rg01_nic-westus
  ]
}

resource "azurerm_virtual_machine_extension" "rg01_vm1_extension" {
  name                 = var.vm1_extension_name
  virtual_machine_id   = azurerm_windows_virtual_machine.rg01_vm1-eastus.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -Command \"netsh advfirewall set allprofiles state off; Install-WindowsFeature -name Web-Server -IncludeManagementTools; New-Item -Path 'C:\\inetpub\\wwwroot\\images' -ItemType Directory -Force; Set-Content -Path 'C:\\inetpub\\wwwroot\\images\\index.html' -Value '<html><body><h1>This is the IMAGES server (VM01)</h1></body></html>'; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '<html><body><h1>This is the default page for VM01</h1><p>Go to <a href=\"/images/\">/images/</a> for the images section</p></body></html>'\""
  })
}

resource "azurerm_virtual_machine_extension" "rg01_vm2_extension" {
  name                 = var.vm2_extension_name
  virtual_machine_id   = azurerm_windows_virtual_machine.rg01_vm2-eastus.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -Command \"netsh advfirewall set allprofiles state off; Install-WindowsFeature -name Web-Server -IncludeManagementTools; New-Item -Path 'C:\\inetpub\\wwwroot\\videos' -ItemType Directory -Force; Set-Content -Path 'C:\\inetpub\\wwwroot\\videos\\index.html' -Value '<html><body><h1>This is the VIDEOS server (VM02)</h1></body></html>'; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '<html><body><h1>This is the default page for VM02</h1><p>Go to <a href=\"/videos/\">/videos/</a> for the videos section</p></body></html>'; Write-Host 'Verifying videos directory exists...'; if (Test-Path 'C:\\inetpub\\wwwroot\\videos') { Write-Host 'Directory exists!' } else { Write-Host 'Directory does not exist!'; throw 'Failed to create videos directory' }; icacls 'C:\\inetpub\\wwwroot\\videos' /grant 'IIS_IUSRS:(OI)(CI)(RX)' /grant 'BUILTIN\\Users:(OI)(CI)(RX)'\""
  })

  # Add a new timeout setting to ensure the script has enough time to complete
  timeouts {
    create = "30m"
  }
}

resource "azurerm_virtual_machine_extension" "rg01_vm_westus_extension" {
  name                 = var.vm_westus_extension_name
  virtual_machine_id   = azurerm_windows_virtual_machine.rg01_vm-westus.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -Command \"netsh advfirewall set allprofiles state off; Install-WindowsFeature -name Web-Server -IncludeManagementTools\""
  })
}
