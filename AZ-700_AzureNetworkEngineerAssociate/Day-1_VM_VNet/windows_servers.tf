// Data sources for existing subnets
data "azurerm_subnet" "rg01_public" {
  name                 = "Public-az700-rg01-vnet-01"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name  = azurerm_resource_group.rg01.name
}

data "azurerm_subnet" "rg02_public" {
  name                 = "Public-az700-rg02-vnet-01"
  virtual_network_name = azurerm_virtual_network.vnet2.name
  resource_group_name  = azurerm_resource_group.rg02.name
}

data "azurerm_subnet" "rg03_public" {
  name                 = "Public-az700-rg03-vnet-01"
  virtual_network_name = azurerm_virtual_network.vnet3.name
  resource_group_name  = azurerm_resource_group.rg03.name
}

// Public IPs
resource "azurerm_public_ip" "rg01_public_ip1" {
  name                = "az700-rg01-public-ip1"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "rg01_public_ip2" {
  name                = "az700-rg01-public-ip2"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "rg02_public_ip" {
  name                = "az700-rg02-public-ip"
  location            = azurerm_resource_group.rg02.location
  resource_group_name = azurerm_resource_group.rg02.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "rg03_public_ip" {
  name                = "az700-rg03-public-ip"
  location            = azurerm_resource_group.rg03.location
  resource_group_name = azurerm_resource_group.rg03.name
  allocation_method   = "Dynamic"
}

// Network Interfaces
resource "azurerm_network_interface" "rg01_nic1" {
  name                = "az700-rg01-nic1"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.rg01_public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg01_public_ip1.id
  }
  accelerated_networking_enabled = false
}

resource "azurerm_network_interface" "rg01_nic2" {
  name                = "az700-rg01-nic2"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.rg01_public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg01_public_ip2.id
  }
  accelerated_networking_enabled = false
}

resource "azurerm_network_interface" "rg02_nic" {
  name                = "az700-rg02-nic"
  location            = azurerm_resource_group.rg02.location
  resource_group_name = azurerm_resource_group.rg02.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.rg02_public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg02_public_ip.id
  }
  accelerated_networking_enabled = false
}

resource "azurerm_network_interface" "rg03_nic" {
  name                = "az700-rg03-nic"
  location            = azurerm_resource_group.rg03.location
  resource_group_name = azurerm_resource_group.rg03.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.rg03_public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg03_public_ip.id
  }
  accelerated_networking_enabled = false
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.rg01_nic1.id
  network_security_group_id = azurerm_network_security_group.rg01-sg.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association1" {
  network_interface_id      = azurerm_network_interface.rg01_nic2.id
  network_security_group_id = azurerm_network_security_group.rg01-sg.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association2" {
  network_interface_id      = azurerm_network_interface.rg02_nic.id
  network_security_group_id = azurerm_network_security_group.rg02-sg.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association3" {
  network_interface_id      = azurerm_network_interface.rg03_nic.id
  network_security_group_id = azurerm_network_security_group.rg03-sg.id
}

// Windows VMs
resource "azurerm_windows_virtual_machine" "rg01_vm1" {
  name                = "az700-rg01-public-vm1"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = "${var.agent_vm_name}-1"
  network_interface_ids = [
    azurerm_network_interface.rg01_nic1.id,
  ]

  availability_set_id = null

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter" #"2022-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_network_security_group.rg01-sg
  ]
}

resource "azurerm_windows_virtual_machine" "rg01_vm2" {
  name                = "az700-rg01-private-vm2"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = "${var.agent_vm_name}-2"
  network_interface_ids = [
    azurerm_network_interface.rg01_nic2.id,
  ]

  availability_set_id = null

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_network_security_group.rg01-sg
  ]
}

resource "azurerm_windows_virtual_machine" "rg02_vm" {
  name                = "az700-rg02-public-vm"
  resource_group_name = azurerm_resource_group.rg02.name
  location            = azurerm_resource_group.rg02.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = var.agent_vm_name
  network_interface_ids = [
    azurerm_network_interface.rg02_nic.id,
  ]

  availability_set_id = null

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_virtual_network.vnet2,
    azurerm_network_security_group.rg02-sg
  ]
}

resource "azurerm_windows_virtual_machine" "rg03_vm" {
  name                = "az700-rg03-public-vm"
  resource_group_name = azurerm_resource_group.rg03.name
  location            = azurerm_resource_group.rg03.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = var.agent_vm_name
  network_interface_ids = [
    azurerm_network_interface.rg03_nic.id,
  ]

  availability_set_id = null

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_virtual_network.vnet3,
    azurerm_network_security_group.rg03-sg
  ]
}
