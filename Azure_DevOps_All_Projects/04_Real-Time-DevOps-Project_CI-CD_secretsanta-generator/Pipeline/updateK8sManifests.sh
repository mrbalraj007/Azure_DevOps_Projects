#!/bin/bash

set -x

# Set the repository URL
#REPO_URL="https://<ACCESS-TOKEN>@dev.azure.com/<AZURE-DEVOPS-ORG-NAME>/voting-app/_git/voting-app"

REPO_URL="https://5vm6s...................@dev.azure.com/mrbalraj/secretsanta-generator/_git/secretsanta-generator"

# Clone the git repository into the /tmp directory
git clone "$REPO_URL" /tmp/temp_repo

# Navigate into the cloned repository directory
cd /tmp/temp_repo

# Make changes to the Kubernetes manifest file(s)
# Update the image name along with the container registry name in the specified deployment.yaml file
sed -i "s|image:.*|image: $1/$2:$3|g" k8s-specifications/$4.yaml

# Configure Git user
git config user.name "Balraj Singh"
git config user.email "your-email@example.com"

# Add the modified files
git add .

# Commit the changes
git commit -m "Update Kubernetes manifest"

# Push the changes back to the repository
git push

# Cleanup: remove the temporary directory
rm -rf /tmp/temp_repo