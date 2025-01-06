#!/bin/bash
sudo apt update -y
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y
#sudo apt install temurin-17-jdk -y
sudo apt install openjdk-17-jre-headless -y
/usr/bin/java --version

##Install Docker and Run SonarQube as Container

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y


sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# sudo apt-get update
# sudo apt-get install docker.io -y
# # sudo usermod -aG docker ubuntu
# # sudo usermod -aG docker jenkins  
# # newgrp docker
sudo chmod 777 /var/run/docker.sock
# Add the current user to the docker group
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker $USER && newgrp docker
# sudo usermod -aG docker $USER

# Enable Docker to start on boot
sudo systemctl enable docker
# Start Docker service
sudo systemctl start docker

# install sonarqube
#docker run -d --name sonar -p 9000:9000 sonarqube:mc1arke/sonarqube-with-community-branch-plugin
docker run -d --name sonar -p 9000:9000 mc1arke/sonarqube-with-community-branch-plugin

#install trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

"echo 'installing maven...'"
#install maven
sudo apt-get update -y
sudo apt-get install maven -y
mvn -version


"echo 'Installing Azure CLI...'"
# install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

"echo 'Show Azure CLI version...'"
az --version


"echo 'installing NPM and Nodejs...'"
#install NPM and Nodejs
sudo apt-get update -y
sudo apt install nodejs npm -y
node -v
npm --version
"echo 'Script is completed...'"