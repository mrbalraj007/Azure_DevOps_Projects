resource "azurerm_resource_group" "example" {
  # name     = "example-resources"
  # location = "West US 2"
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.example]
}

resource "azurerm_public_ip" "example" {
  name                = each.value.ip_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  for_each            = var.vm


  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface" "example" {
  name                = each.value.nic_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  for_each            = var.vm
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[each.key].id
  }
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name              = "test-sg"
    priority          = 100
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    #destination_port_range     = "*"
    destination_port_ranges    = ["22", "80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example[each.key].id
  network_security_group_id = azurerm_network_security_group.example.id
  for_each                  = var.vm
}


resource "azurerm_linux_virtual_machine" "example" {
  name                = each.value.vm_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B2ms"
  computer_name       = "hostname-${each.value.vm_name}"
  admin_username      = "azureuser"
  #admin_password                  = "Windows@123456"
  for_each                        = var.vm
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.example[each.key].id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("./id_rsa.pub")
  }

  os_disk {
    name                 = "osdisk-${each.value.vm_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}