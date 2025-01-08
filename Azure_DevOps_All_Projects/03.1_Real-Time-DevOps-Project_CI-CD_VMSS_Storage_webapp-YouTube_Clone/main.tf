resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myfirst-demo-20012025-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "myfirst-demo-20012025-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  lifecycle {
    ignore_changes = [
      # Ignore changes to the subnet if it has been deleted manually
      id,
    ]
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "vmssagentspool"
  location            = var.location
  resource_group_name = var.resource_group_name
  upgrade_mode        = "Manual"
  sku                 = "Standard_D2_v4"
  instances           = 2

  zones = ["1", "2", "3"]

  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
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

  identity {
    type = "SystemAssigned"
  }

  network_interface {
    name    = "vmssagentspool-nic"
    primary = true

    ip_configuration {
      name      = "vmssagentspool-ipconfig"
      subnet_id = azurerm_subnet.subnet.id
      primary   = true
    }
  }

  single_placement_group      = false
  platform_fault_domain_count = 1
  overprovision               = false

  depends_on = [azurerm_virtual_network.vnet]
}