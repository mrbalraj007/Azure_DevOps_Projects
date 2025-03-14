```sh
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- main

pool:
  name: Terraform-Demo-pool

stages:
  - stage: Build
    jobs:
    - job: Build
      steps:
      - task: TerraformTaskV4@4
        displayName: Terrafotrm int
        inputs:
          provider: 'azurerm'
          command: 'init'
          backendServiceArm: 'MyAzureServiceConnection'
          backendAzureRmResourceGroupName: 'myfirst-demo-09012025-rg'
          backendAzureRmStorageAccountName: 'storageacct7563c485'
          backendAzureRmContainerName: 'tfstate'
          backendAzureRmKey: 'prod.terraform.tfstate'
      - task: TerraformTaskV4@4
        displayName: Terraform validate
        inputs:
          provider: 'azurerm'
          command: 'validate'
      - task: TerraformTaskV4@4
        displayName: Terraform formatting
        inputs:
          provider: 'azurerm'
          command: 'custom'
          outputTo: 'console'
          customCommand: 'fmt'
          environmentServiceNameAzureRM: 'MyAzureServiceConnection'
      - task: TerraformTaskV4@4
        displayName: Terraform plan
        inputs:
          provider: 'azurerm'
          command: 'plan'
          commandOptions: '-out $(Build.SourcesDirectory)/tfplanfile'
          environmentServiceNameAzureRM: 'MyAzureServiceConnection'
      - task: ArchiveFiles@2
        displayName: Archive Files
        inputs:
          #rootFolderOrFile: '$(Build.SourcesDirectory)'
          rootFolderOrFile: '$(Build.SourcesDirectory)/'
          #includeRootFolder: true
          includeRootFolder: false
          archiveType: 'zip'
          archiveFile: '$(Build.ArtifactStagingDirectory)/$(Build.BuildId).zip'
          replaceExistingArchive: true
      - task: PublishBuildArtifacts@1
        displayName: Publish Artifact
        inputs:
          PathtoPublish: '$(Build.ArtifactStagingDirectory)'
          ArtifactName: '$(Build.BuildId)-build'
          publishLocation: 'Container'
```