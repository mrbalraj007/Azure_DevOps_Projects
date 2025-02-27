```sh
trigger:
- none

resources:
  pipelines:
  - pipeline: Build-Pipeline
    source: Build-Pipeline  # use the name of the CI pipeline you just created
    trigger: true

variables:
  - group: rg-variables

stages:
- stage: Cloud_Infra
  displayName: 'Provision Azure & AWS Infra'

  pool:
    #name: Default
    vmImage: ubuntu-latest
  jobs:
    - job: TerraformSetup
      displayName: 'Terraform process'
      steps:
      - task: TerraformCLI@2
        displayName: 'Terraform Version'
        inputs:
          command: 'version'
          workingDirectory: '$(System.DefaultWorkingDirectory)/Terraform'
          commandOptions: '--version'
          allowTelemetryCollection: true

      - task: DownloadSecureFile@1
        displayName: 'Download Public Key'
        name: DownloadPublicKey
        inputs:
          secureFile: 'id_rsa.pub'  # Name of the uploaded secure file (public key)

      - script: |
          mkdir -p $(Agent.TempDirectory)/keys
          cp $(DownloadPublicKey.secureFilePath) $(Agent.TempDirectory)/keys/id_rsa.pub
        displayName: 'Prepare Public Key'

      - task: TerraformTaskV4@4
        displayName: 'Terraform init'
        inputs:
          provider: 'azurerm'
          command: 'init'
          workingDirectory: '$(System.DefaultWorkingDirectory)/Terraform'
          backendServiceArm: 'Azure-Service-Connection'
          backendAzureRmResourceGroupName: 'devops-rg'
          backendAzureRmStorageAccountName: 'storageacct72bee084'
          backendAzureRmContainerName: 'tfstates'
          backendAzureRmKey: 'terraform.tfstate'

      - task: TerraformCLI@2
        displayName: 'Terraform Plan'
        inputs:
          command: 'plan'
          workingDirectory: '$(System.DefaultWorkingDirectory)/Terraform'
          environmentServiceName: 'Azure-service-connection'
          commandOptions: '-var public_key_path=$(Agent.TempDirectory)/keys/id_rsa.pub'
          allowTelemetryCollection: true
          providerServiceAws: 'AWS-service-connection'
          providerAwsRegion: 'us-east-1'
  
      - task: TerraformCLI@2
        displayName: 'Terraform Apply'
        inputs:
          command: 'apply'
          workingDirectory: '$(System.DefaultWorkingDirectory)/Terraform'
          environmentServiceName: 'Azure-service-connection'
          commandOptions: '-auto-approve -var public_key_path=$(Agent.TempDirectory)/keys/id_rsa.pub'
          allowTelemetryCollection: true
          providerServiceAws: 'AWS-service-connection'
          providerAwsRegion: 'us-east-1'

      - task: TerraformCLI@2
        displayName: 'Terraform Output'
        inputs:
          command: 'output'
          workingDirectory: '$(System.DefaultWorkingDirectory)/Terraform'
          allowTelemetryCollection: true
        continueOnError: true

```