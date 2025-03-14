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
  }
  accelerated_networking_enabled = false
  depends_on                     = [azurerm_virtual_network.vnet1]
}

// Network Interface for Private VM in Central India - Updated without public IP
resource "azurerm_network_interface" "rg01_nic-centralindia-private" {
  name                = var.name_rg01_nic-centralindia-private
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.vnet1.id}/subnets/${var.centralindia_private_subnet_name}"
    private_ip_address_allocation = "Dynamic"
  }
  accelerated_networking_enabled = false
  depends_on                     = [azurerm_virtual_network.vnet1]
}

resource "azurerm_network_interface_security_group_association" "nsg_association_centralindia" {
  network_interface_id      = azurerm_network_interface.rg01_nic-centralindia.id
  network_security_group_id = azurerm_network_security_group.rg01-sg-centralindia.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association_centralindia_private" {
  network_interface_id      = azurerm_network_interface.rg01_nic-centralindia-private.id
  network_security_group_id = azurerm_network_security_group.rg01-sg-centralindia.id
}

// Windows VMs
resource "azurerm_windows_virtual_machine" "rg01_vm-centralindia" {
  name                = var.name_rg01_vm-centralindia
  resource_group_name = azurerm_resource_group.rg01.name
  location            = var.location_01
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = "${var.agent_vm_name}-in-public"
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

// Private Windows VM in Central India
resource "azurerm_windows_virtual_machine" "rg01_vm-centralindia-private" {
  name                = var.name_rg01_vm-centralindia-private
  resource_group_name = azurerm_resource_group.rg01.name
  location            = var.location_01
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = "${var.agent_vm_name}-in-private"
  network_interface_ids = [
    azurerm_network_interface.rg01_nic-centralindia-private.id,
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
    azurerm_network_interface.rg01_nic-centralindia-private
  ]
}

resource "azurerm_virtual_machine_extension" "rg01_vm_centralindia_extension" {
  name                 = var.vm_centralindia_extension_name
  virtual_machine_id   = azurerm_windows_virtual_machine.rg01_vm-centralindia.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -Command \"netsh advfirewall set allprofiles state off; Install-WindowsFeature -name Web-Server -IncludeManagementTools; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '${var.web_page_content_public}'\""
  })
}

resource "azurerm_virtual_machine_extension" "rg01_vm_centralindia_private_extension" {
  name                 = var.vm_centralindia_private_extension_name
  virtual_machine_id   = azurerm_windows_virtual_machine.rg01_vm-centralindia-private.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -Command \"netsh advfirewall set allprofiles state off; Install-WindowsFeature -name Web-Server -IncludeManagementTools; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '${var.web_page_content_private}'\""
  })
}

// Reference example for retrieving secrets from Key Vault:
/*
// Data sources to retrieve secrets from Key Vault
data "azurerm_key_vault_secret" "admin_username" {
  name         = "vm-admin-username"
  key_vault_id = azurerm_key_vault.vm_key_vault.id
  depends_on   = [azurerm_key_vault_secret.admin_username]
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = "vm-admin-password"
  key_vault_id = azurerm_key_vault.vm_key_vault.id
  depends_on   = [azurerm_key_vault_secret.admin_password]
}

// Then in the VM resource, you would use:
admin_username = data.azurerm_key_vault_secret.admin_username.value
admin_password = data.azurerm_key_vault_secret.admin_password.value
*/
