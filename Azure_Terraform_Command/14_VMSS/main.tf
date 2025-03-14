resource "azurerm_resource_group" "rg" {
  name     = "myfirst-demo-20012025-rg"
  location = "Australia East"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myfirst-demo-20012025-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "myfirst-demo-20012025-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "myfirst-demo-20012025"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  upgrade_mode        = "Manual"
  sku                 = "Standard_B1s"
  instances           = 2

  zones = ["1", "2", "3"]

  admin_username = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  network_interface {
    name    = "myfirst-demo-20012025-nic"
    primary = true

    ip_configuration {
      name      = "myfirst-demo-20012025-ipconfig"
      subnet_id = azurerm_subnet.subnet.id
      primary   = true
    }
  }
}