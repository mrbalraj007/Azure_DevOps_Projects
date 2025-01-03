# resource "azurerm_resource_group" "example" {
#   name     = var.resource_group_name_prefix
#   location = var.resource_group_location
# }

resource "local_file" "public_key" {
  filename = "${path.module}/id_rsa.pub"
  content  = file("${path.module}/id_rsa.pub")
}

resource "local_file" "private_key" {
  filename = "${path.module}/id_rsa"
  content  = file("${path.module}/id_rsa")
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.example]
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  depends_on          = [azurerm_resource_group.rg]

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_resource_group.rg]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_resource_group.rg]

  security_rule {
    name                       = "allow-ssh-http-https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-port-range"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["30000-33000"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
  depends_on                = [azurerm_network_interface.example, azurerm_network_security_group.example]
}

resource "azurerm_linux_virtual_machine" "example" {
  name                            = "devops-demo_vm"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B1ms" # Reduced VM size to use fewer cores
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.example.id]
  computer_name                   = "devopsdemovm"
  depends_on                      = [azurerm_network_interface.example]

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = local_file.public_key.content
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Updating package list...'",
      "sudo apt-get update",
      "echo 'Installing required packages...'",
      "sudo apt-get install -y curl wget apt-transport-https ca-certificates software-properties-common gnupg lsb-release",
      "echo 'Adding Docker GPG key...'",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo 'Adding Docker repository...'",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "echo 'Updating package list again...'",
      "sudo apt-get update -y",
      "echo 'Installing Docker...'",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "echo 'Starting Docker service...'",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "echo 'Adding user to Docker group...'",
      "sudo usermod -aG docker $USER",
      "echo 'Installing kubectl...'",
      "curl -LO \"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\"",
      "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
      "echo 'Installing Azure CLI...'",
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
      "echo 'Show Azure CLI version...'",
      "sudo az version",
      "echo 'Script is completed...'",
    ]

    connection {
      host        = azurerm_public_ip.example.ip_address
      user        = "azureuser"
      private_key = local_file.private_key.content
      type        = "ssh"
    }
  }
}

resource "random_id" "acr" {
  keepers = {
    # Generate a new id each time the resource group name changes
    resource_group_name = var.resource_group_name
  }

  byte_length = 4
}

resource "azurerm_container_registry" "example" {
  name                = "aconreg${random_id.acr.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true

  tags = {
    environment = "test"
  }
}



