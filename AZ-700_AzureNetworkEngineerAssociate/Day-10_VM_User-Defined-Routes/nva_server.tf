// Public IP for NVA VM in Central India
resource "azurerm_public_ip" "rg01_public_ip-centralindia-nva" {
  name                = var.name_rg01_public_ip-centralindia-nva
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.dns_label_prefix_centralindia_nva}-${random_string.dns_prefix.result}"
  depends_on          = [azurerm_virtual_network.vnet1]
}

// Network Interface for NVA VM in Central India
resource "azurerm_network_interface" "rg01_nic-centralindia-nva" {
  name                = var.name_rg01_nic-centralindia-nva
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.vnet1.id}/subnets/${var.centralindia_nva_subnet_name}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg01_public_ip-centralindia-nva.id
  }

  # Enable IP forwarding for the NVA
  ip_forwarding_enabled          = true
  accelerated_networking_enabled = false
  depends_on                     = [azurerm_virtual_network.vnet1]
}

resource "azurerm_network_interface_security_group_association" "nsg_association_centralindia_nva" {
  network_interface_id      = azurerm_network_interface.rg01_nic-centralindia-nva.id
  network_security_group_id = azurerm_network_security_group.rg01-sg-centralindia.id
}

// NVA VM in Central India
resource "azurerm_windows_virtual_machine" "rg01_vm-centralindia-nva" {
  name                = var.name_rg01_vm-centralindia-nva
  resource_group_name = azurerm_resource_group.rg01.name
  location            = var.location_01
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = "${var.agent_vm_name}-in-nva"
  network_interface_ids = [
    azurerm_network_interface.rg01_nic-centralindia-nva.id,
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
    azurerm_network_interface.rg01_nic-centralindia-nva
  ]
}

resource "azurerm_virtual_machine_extension" "rg01_vm_centralindia_nva_extension" {
  name                 = var.vm_centralindia_nva_extension_name
  virtual_machine_id   = azurerm_windows_virtual_machine.rg01_vm-centralindia-nva.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -Command \"netsh advfirewall set allprofiles state off; Install-WindowsFeature -name Web-Server -IncludeManagementTools; Install-WindowsFeature -Name RemoteAccess -IncludeManagementTools; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '${var.web_page_content_nva}'; New-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters' -Name 'IPEnableRouter' -Value 1 -PropertyType DWord -Force; Get-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters' -Name 'IPEnableRouter' | Out-File C:\\ipenablerouter_status.txt\""
  })
}
