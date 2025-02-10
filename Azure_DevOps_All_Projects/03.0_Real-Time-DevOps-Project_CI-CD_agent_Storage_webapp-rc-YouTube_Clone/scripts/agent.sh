#!/bin/bash
set -e
sudo apt update && sudo apt install -y wget curl unzip
mkdir -p /home/azureuser/azagent && cd /home/azureuser/azagent
wget wget https://vstsagentpackage.azureedge.net/agent/4.248.0/vsts-agent-linux-x64-4.248.0.tar.gz
tar -xvf vsts-agent-linux-x64-4.248.0.tar.gz
./config.sh --unattended --url https://dev.azure.com/mrbalraj \
            --auth pat --token 47olvKvZl7OtLNUdPgntt5w16Il6ybKi8mh5octeYYxptOp2m0QZJQQJ99ALACAAAAAAAAAAAAASAZDOIYnw \
            --pool devops-demo_vm \
            --agent $(hostname) \
            --acceptTeeEula
sudo ./svc.sh install
sudo ./svc.sh start