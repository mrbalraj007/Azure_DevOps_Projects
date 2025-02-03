```sh
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
- stage: destroy_aks
  #dependsOn: create_aks
  jobs:
  - job: destroy_aks_job
    displayName: 'Destroy Azure kubernetes'
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
        command: 'destroy'
        workingDirectory: '$(Build.SourcesDirectory)/private-aks'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'
- stage: destroy_appgw
  #dependsOn: create_aks
  jobs:
  - job: destroy_appgw_job
    displayName: 'Destroy appgw'
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
        command: 'destroy'
        workingDirectory: '$(Build.SourcesDirectory)/application-gateway'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'

- stage: destroy_acr
  #dependsOn: create_acr
  jobs:
  - job: destroy_acr_job
    displayName: 'Destroy Azure Container Registry'
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
        command: 'destroy'
        workingDirectory: '$(Build.SourcesDirectory)/private-acr'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'
- stage: destroy_db
  jobs:
  - job: destroy_db_job
    displayName: 'destroy Sql Server'
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
        command: 'destroy'
        workingDirectory: '$(Build.SourcesDirectory)/sql-dbserver'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'

- stage: destroy_vm
  #dependsOn: destroy_acr
  jobs:
  - job: destroy_vm_job
    displayName: 'Destroy Virtual Machine'
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
    - task: TerraformTaskV4@4
      inputs:
        provider: 'azurerm'
        command: 'destroy'
        workingDirectory: '$(Build.SourcesDirectory)/agent-vm'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'

- stage: destroy_vnet
  dependsOn: destroy_vm
  jobs:
  - job: destroy_vnet_job
    displayName: 'Destroy Virtual Network'
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
        command: 'destroy'
        workingDirectory: '$(Build.SourcesDirectory)/virtual-network'
        commandOptions: '-auto-approve'
        environmentServiceNameAzureRM: 'Azure Service Connection'

```