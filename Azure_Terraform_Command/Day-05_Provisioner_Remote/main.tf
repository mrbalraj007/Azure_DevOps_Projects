provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.resource_group_location
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
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "test-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443", "32323"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "test"
  }
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_linux_virtual_machine" "example" {
  name                            = "example-machine"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  size                            = "Standard_A2_V2"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

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
    public_key = file("id_ed25519.pub")
  }

  connection {
    host        = self.public_ip_address
    user        = "azureuser"
    private_key = file("id_ed25519")
    type        = "ssh"
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
        "echo 'Verifying Docker installation...'",
        "sudo docker --version",
        "echo 'Configuring containerd...'",
        "sudo mkdir -p /etc/containerd",
        "containerd config default | sudo tee /etc/containerd/config.toml",
        "sudo systemctl restart containerd",
        "echo 'Downloading Minikube...'",
        "wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
        "chmod +x minikube-linux-amd64",
        "sudo mv minikube-linux-amd64 /usr/local/bin/minikube",
        "echo 'Installing conntrack and crictl...'",
        "sudo apt-get install -y conntrack",
        "curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.24.0/crictl-v1.24.0-linux-amd64.tar.gz",
        "sudo tar zxvf crictl-v1.24.0-linux-amd64.tar.gz -C /usr/local/bin",
        "echo 'Installing containernetworking-plugins...'",
        "wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz",
        "sudo mkdir -p /opt/cni/bin",
        "sudo tar -xzf cni-plugins-linux-amd64-v1.1.1.tgz -C /opt/cni/bin",
        "echo 'Installing kubectl...'",
        "curl -LO \"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\"",
        "chmod +x kubectl",
        "sudo mv kubectl /usr/local/bin/",
        "echo 'Creating .kube and .minikube directories...'",
        "mkdir -p $HOME/.kube $HOME/.minikube",
        "echo 'Changing ownership of .kube and .minikube directories...'",
        "sudo chown -R $USER $HOME/.kube $HOME/.minikube",
        "echo 'Creating /etc/cni/net.d directory...'",
        "sudo mkdir -p /etc/cni/net.d",
        "echo 'Starting Minikube...'",
        "sudo sysctl fs.protected_regular=0",
        "sudo minikube start --driver=none --container-runtime=containerd --kubernetes-version=v1.31.0",
        "echo 'Provisioning complete.'"
    ]

    connection {
      host        = azurerm_public_ip.example.ip_address
      user        = "azureuser"
      private_key = file("id_ed25519")
      type        = "ssh"
      timeout     = "30m"
    }
  }
}