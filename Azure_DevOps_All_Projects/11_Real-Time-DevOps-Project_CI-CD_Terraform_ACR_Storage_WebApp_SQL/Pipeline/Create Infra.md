```sh

trigger:
- none

resources:
  repositories:
  - repository: self

variables:
  - group: global-variables
  - group: vnet-variables
  - group: vm_variables
  - group: acr_variables
  - group: aks_variables
  - group: appgw_variables
  - group: db_variables

pool:
  vmImage: ubuntu-latest

stages:
- stage: create_vnet
  jobs:
  - job: create_vnet_job
    displayName: 'Create Virtual Network'
    steps:
    - checkout: self
    - task: TerraformInstaller@1
      inputs:
        terraformVersion: 'latest'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'init'
        workingDirectory: '$(Build.SourcesDirectory)/virtual-network'
        backendServiceArm: 'Azure Service Connection'
        backendAzureRmResourceGroupName: 'rg-devops'
        backendAzureRmStorageAccountName: 'storageacctd2e215eb'
        backendAzureRmContainerName: 'tfstates'
        backendAzureRmKey: 'vnet.tfstate'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'apply'
        workingDirectory: '$(Build.SourcesDirectory)/virtual-network'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'

- stage: create_vm
  dependsOn: create_vnet
  jobs:
  - job: create_vm_job
    displayName: 'Create Virtual Machine'
    steps:
    - checkout: self
    - task: TerraformInstaller@1
      inputs:
        terraformVersion: 'latest'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'init'
        workingDirectory: '$(Build.SourcesDirectory)/agent-vm'
        backendServiceArm: 'Azure Service Connection'
        backendAzureRmResourceGroupName: 'rg-devops'
        backendAzureRmStorageAccountName: 'storageacctd2e215eb'
        backendAzureRmContainerName: 'tfstates'
        backendAzureRmKey: 'vm.tfstate'
    - script: |
        sed -i 's/\r$//' script.sh
      displayName: 'Fix line endings'
      workingDirectory: '$(Build.SourcesDirectory)/agent-vm'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'apply'
        workingDirectory: '$(Build.SourcesDirectory)/agent-vm'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'

- stage: create_acr
  dependsOn: create_vm
  jobs:
  - job: create_acr_job
    displayName: 'Create Azure Container Registry'
    steps:
    - checkout: self
    - task: TerraformInstaller@1
      inputs:
        terraformVersion: 'latest'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'init'
        workingDirectory: '$(Build.SourcesDirectory)/private-acr'
        backendServiceArm: 'Azure Service Connection'
        backendAzureRmResourceGroupName: 'rg-devops'
        backendAzureRmStorageAccountName: 'storageacctd2e215eb'
        backendAzureRmContainerName: 'tfstates'
        backendAzureRmKey: 'acr.tfstate'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'apply'
        workingDirectory: '$(Build.SourcesDirectory)/private-acr'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'

- stage: create_db
  jobs:
  - job: create_db_job
    displayName: 'Create Sql Server'
    steps:
    - checkout: self
    - task: TerraformInstaller@1
      inputs:
        terraformVersion: 'latest'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'init'
        workingDirectory: '$(Build.SourcesDirectory)/sql-dbserver'
        backendServiceArm: 'Azure Service Connection'
        backendAzureRmResourceGroupName: 'rg-devops'
        backendAzureRmStorageAccountName: 'storageacctd2e215eb'
        backendAzureRmContainerName: 'tfstates'
        backendAzureRmKey: 'db.tfstate'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'apply'
        workingDirectory: '$(Build.SourcesDirectory)/sql-dbserver'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'

- stage: create_appgw
  #dependsOn: create_appgw
  jobs:
  - job: create_appgw_job
    displayName: 'Create Application Gateway'
    steps:
    - checkout: self
    - task: TerraformInstaller@1
      inputs:
        terraformVersion: 'latest'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'init'
        workingDirectory: '$(Build.SourcesDirectory)/application-gateway'
        backendServiceArm: 'Azure Service Connection'
        backendAzureRmResourceGroupName: 'rg-devops'
        backendAzureRmStorageAccountName: 'storageacctd2e215eb'
        backendAzureRmContainerName: 'tfstates'
        backendAzureRmKey: 'appgw.tfstate'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'apply'
        workingDirectory: '$(Build.SourcesDirectory)/application-gateway'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'
- stage: create_aks
  #dependsOn: create_acr
  jobs:
  - job: create_aks_job
    displayName: 'Create Azure kubernetes services'
    steps:
    - checkout: self
    - task: TerraformInstaller@1
      inputs:
        terraformVersion: 'latest'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'init'
        workingDirectory: '$(Build.SourcesDirectory)/private-aks'
        backendServiceArm: 'Azure Service Connection'
        backendAzureRmResourceGroupName: 'rg-devops'
        backendAzureRmStorageAccountName: 'storageacctd2e215eb'
        backendAzureRmContainerName: 'tfstates'
        backendAzureRmKey: 'aks.tfstate'
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'apply'
        workingDirectory: '$(Build.SourcesDirectory)/private-aks'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'
```