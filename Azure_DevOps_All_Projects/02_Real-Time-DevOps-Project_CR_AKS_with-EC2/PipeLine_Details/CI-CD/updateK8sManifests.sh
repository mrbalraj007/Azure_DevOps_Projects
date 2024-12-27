#!/bin/bash

set -x

# Set the repository URL
#REPO_URL="https://<ACCESS-TOKEN>@dev.azure.com/<AZURE-DEVOPS-ORG-NAME>/voting-app/_git/voting-app"

REPO_URL="https://5vm6sS6s9O3JCB68OG55rQNUqCNK8F9wAz5FWFPBfmcYcYvTuJNsJQQJ99ALACAAAAAAAAAAAAASAZDODfBe@dev.azure.com/mrbalraj/balraj-devops/_git/balraj-devops"

# Clone the git repository into the /tmp directory
git clone "$REPO_URL" /tmp/temp_repo

# Navigate into the cloned repository directory
cd /tmp/temp_repo

# Make changes to the Kubernetes manifest file(s)
# For example, let's say you want to change the image tag in a deployment.yaml file
#sed -i "s|image:.*|image: <ACR-REGISTRY-NAME>/$2:$3|g" k8s-specifications/$1-deployment.yaml

sed -i "s|image:.*|image: aconregee7b05ba.azurecr.io/$2:$3|g" k8s-specifications/$1-deployment.yaml

# Add the modified files
git add .

# Commit the changes
git commit -m "Update Kubernetes manifest"

# Push the changes back to the repository
git push

# Cleanup: remove the temporary directory
rm -rf /tmp/temp_repo