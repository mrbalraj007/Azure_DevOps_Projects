#!/bin/bash
set -e

# Update package list
sudo apt update -y

# Ensure the keyrings directory exists
sudo mkdir -p /etc/apt/keyrings

# Add Adoptium GPG key and repository
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb bionic main" | sudo tee /etc/apt/sources.list.d/adoptium.list

# Update package list again
sudo apt update -y

# Install OpenJDK 17
sudo apt install openjdk-17-jre-headless -y
/usr/bin/java --version

# Install Docker and run SonarQube as a container
sudo apt-get update
sudo apt-get install ca-certificates curl software-properties-common -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
sudo apt-get update -y

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Set permissions for Docker
sudo chmod 777 /var/run/docker.sock
sudo chown $(whoami) /var/run/docker.sock
sudo usermod -aG docker $(whoami) && newgrp docker

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Run SonarQube container
if [ "$(docker ps -aq -f name=sonar)" ]; then
    # Remove existing container if it exists
    docker rm -f sonar
fi
docker run -d --name sonar -p 9000:9000 mc1arke/sonarqube-with-community-branch-plugin

# Install Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb bionic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

# Install Maven
echo 'installing maven...'
sudo apt-get update -y
sudo apt-get install maven -y
mvn -version

# Install Azure CLI
echo 'Installing Azure CLI...'
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Show Azure CLI version
echo 'Show Azure CLI version...'
az --version

# Install NPM and Node.js
echo 'installing NPM and Nodejs...'
sudo apt-get update -y
sudo apt-get remove -y nodejs npm
sudo apt-get autoremove -y
sudo apt-get clean
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get update -y
sudo apt-get install -y nodejs
sudo apt-get install -f -y  # Fix broken dependencies
sudo apt-get install -y npm
node -v
npm --version

echo 'Script is completed...'