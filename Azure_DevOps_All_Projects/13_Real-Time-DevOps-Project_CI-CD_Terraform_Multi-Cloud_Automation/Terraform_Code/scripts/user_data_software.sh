#!/bin/bash
set -e

# Update package list
echo 'Updating package list...'
sudo apt update -y

# Ensure the keyrings directory exists
echo 'Ensuring keyrings directory exists...'
sudo mkdir -p /etc/apt/keyrings

# Add Adoptium GPG key and repository
echo 'Adding Adoptium GPG key and repository...'
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb bionic main" | sudo tee /etc/apt/sources.list.d/adoptium.list

# Update package list again
echo 'Updating package list again...'
sudo apt update -y

# Install OpenJDK 17
echo 'Installing OpenJDK 17...'
sudo apt install openjdk-17-jre-headless -y
/usr/bin/java --version

# Install Docker and run SonarQube as a container
echo 'Installing Docker...'
sudo apt-get update -y
sudo apt-get install ca-certificates curl software-properties-common -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo 'Adding Docker repository...'
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
echo 'Updating package list again...'
sudo apt-get update -y

# Install Docker
echo 'Installing Docker...'
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Set permissions for Docker
echo 'Setting permissions for Docker...'
sudo chmod 777 /var/run/docker.sock
sudo chown $(whoami) /var/run/docker.sock
sudo usermod -aG docker $(whoami) && newgrp docker

# Enable and start Docker service
echo 'Enabling and starting Docker service...'
sudo systemctl enable docker
sudo systemctl start docker

# Run SonarQube container
echo 'Running SonarQube container...'
if [ "$(docker ps -aq -f name=sonar)" ]; then
    # Remove existing container if it exists
    docker rm -f sonar
fi
docker run -d --name sonar -p 9000:9000 mc1arke/sonarqube-with-community-branch-plugin

# Install Trivy
echo 'Installing Trivy...'
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb bionic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

# Install Maven
echo 'Installing Maven...'
sudo apt-get update -y
sudo apt-get install maven -y
mvn -version

# Debug statement
echo 'Maven installed successfully'

# Install Azure CLI
echo 'Installing Azure CLI...'
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Debug statement
echo 'Azure CLI installed successfully'

# Show Azure CLI version
az --version

# To configure the PPA on your system and install Ansible run these commands:
echo 'Installing Ansible...'
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

echo 'Ansible installed successfully'

# Ensure pip is installed
echo 'Ensuring pip is installed...'
#sudo apt-get install -y python3-pip
sudo systemctl stop unattended-upgrades
sudo systemctl disable unattended-upgrades
sudo apt-get update  # Update package list before installation (good practice)
sudo apt-get install -y -o Dpkg::Options::="--force-confnew" python3-pip

echo 'python3-pip installed successfully'

# To install azure.storage.blob module.
echo 'Installing azure-storage-blob module...'
sudo pip3 install azure-storage-blob

echo 'azure-storage-blob installed successfully'

# Install .NET SDK
echo 'Installing .NET SDK...'
sudo apt-get install -y dotnet-sdk-7.0  # Adjust version as needed

# Debug statement
echo '.NET SDK installed successfully'

# Set HOME environment variable
export HOME=/home/$(whoami)

# Install Entity Framework Core tools globally
echo 'Installing Entity Framework Core tools...'
dotnet tool install --global dotnet-ef --version 7.0.3

# Debug statement
echo 'Entity Framework Core tools installed successfully'

# Install Entity Framework Core tools globally
echo 'Installing jq ...'

sudo apt  install jq -y
# Debug statement
echo 'jq installed successfully'

echo 'Script is completed...'