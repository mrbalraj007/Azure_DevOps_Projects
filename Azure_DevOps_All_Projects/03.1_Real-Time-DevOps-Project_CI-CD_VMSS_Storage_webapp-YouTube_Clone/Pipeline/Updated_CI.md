```sh
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- main
#- none

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
```