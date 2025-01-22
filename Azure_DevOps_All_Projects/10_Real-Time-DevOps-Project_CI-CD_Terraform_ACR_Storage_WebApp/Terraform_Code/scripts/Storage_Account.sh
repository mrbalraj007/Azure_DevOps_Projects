#!/bin/bash

RESOURCE_GROUP_NAME=rg-30012025
#STORAGE_ACCOUNT_NAME=tfstate$RANDOM
STORAGE_ACCOUNT_NAME=storage30012025
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

#List All Storage Accounts
az storage account list --output table

# List All Containers in a Storage Account
az storage container list --account-name <STORAGE_ACCOUNT_NAME> --output table

# To delete a storage account
az storage account delete --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --yes

