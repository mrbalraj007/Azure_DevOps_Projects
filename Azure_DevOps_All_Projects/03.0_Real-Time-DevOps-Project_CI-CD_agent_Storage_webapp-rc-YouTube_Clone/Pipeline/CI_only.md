# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
#- main
- none

pool:
  name: devops-demo_vm

stages:
  - stage: Build
    jobs:
    - job: Build
      steps:
      - task: Npm@1
        inputs:
          command: 'install'
      - task: Npm@1
        inputs:
          command: 'custom'
          customCommand: 'run build'
      - task: PublishBuildArtifacts@1
        inputs:
          PathtoPublish: 'build'
          ArtifactName: 'drop'
          publishLocation: 'Container'
          
  - stage: Deploy
    jobs:
    - job: Deploy
      steps:
      - task: DownloadBuildArtifacts@1
        inputs:
          buildType: 'current'
          downloadType: 'single'
          artifactName: 'drop'
          downloadPath: '$(System.ArtifactsDirectory)'
      - task: AzureRmWebAppDeployment@4
        inputs:
          ConnectionType: 'AzureRM'
          azureSubscription: 'Free Trial(2fc598a4-6a52-44b9-b476-6a62640513f8)'
          appType: 'webAppLinux'
          WebAppName: 'myfirst-demo-webapp'
          packageForLinux: '$(System.ArtifactsDirectory)/drop'
          RuntimeStack: 'STATICSITE|1.0'