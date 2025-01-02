```bash
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- none

pool:
  name: devops-demo_vm
  demands: agent.name -equals agent-1

variables:
  azureSubscription: 'azure-conn'
  containerRegistry: 'aconreg05a01096.azurecr.io'  # Full registry URL for Trivy scan
  repository: 'dev'
  imageTag: 'latest'

stages:

# Add Compiling.
  - stage: CompileJob
    displayName: 'Maven Compile'
    jobs:
    - job: maven_compile
      displayName: 'maven_compile'
      steps:
      - task: Maven@4
        inputs:
          azureSubscription: '$(azureSubscription)'
          mavenPomFile: 'pom.xml'
          goals: 'compile'
          publishJUnitResults: true
          testResultsFiles: '**/surefire-reports/TEST-*.xml'
          javaHomeOption: 'JDKVersion'
          mavenVersionOption: 'Default'
          mavenAuthenticateFeed: false
          effectivePomSkip: false
          sonarQubeRunAnalysis: false

# Add Testing
  - stage: Test
    displayName: 'Maven Test'
    jobs:
      - job: maven_test
        displayName: 'Unit_Test'
        steps:
          - task: Maven@4
            inputs:
              azureSubscription: '$(azureSubscription)'
              mavenPomFile: 'pom.xml'
              goals: 'test'
              publishJUnitResults: true
              testResultsFiles: '**/surefire-reports/TEST-*.xml'
              javaHomeOption: 'JDKVersion'
              mavenVersionOption: 'Default'
              mavenAuthenticateFeed: false
              effectivePomSkip: false
              sonarQubeRunAnalysis: false

# Add Trivy FS scan image.  
  - stage: Trivy_FS_Scan
    displayName: 'Trivy_FS_Scan'
    jobs:
      - job: Trivy_FS_Scan
        displayName: 'Trivy FS Scan'       
        steps:
          - task: CmdLine@2
            inputs:
              script: 'trivy fs --format table -o trivy-fs-report.html .'

# Add SonarQube  
  - stage: SonarQube
    displayName: 'SonarAnalysis'
    jobs:
      - job: SonarQube_analysis
        steps:
          - task: SonarQubePrepare@7
            inputs:
              SonarQube: 'sonar-conn'
              scannerMode: 'cli'
              configMode: 'manual'
              cliProjectKey: 'bankapp'
              cliProjectName: 'bankapp'
              cliSources: '.'
              extraProperties: 'sonar.java.binaries=.' 
          - task: SonarQubeAnalyze@7
            inputs:
              jdkversion: 'JAVA_HOME_17_X64'
# To Publish the Artifacts.
  - stage: Publish_Artifact
    displayName: 'Publish_Build_Artifacts'
    jobs:
      - job: publish_artifacts
        displayName: 'Publish_build_Artifacts'
        steps:
          - task: MavenAuthenticate@0
            inputs:
              artifactsFeeds: 'store_artifact_maven'
          - task: Maven@4
            inputs:
              azureSubscription: '$(azureSubscription)'
              mavenPomFile: 'pom.xml'
              goals: 'deploy'
              publishJUnitResults: true
              testResultsFiles: '**/surefire-reports/TEST-*.xml'
              javaHomeOption: 'JDKVersion'
              mavenVersionOption: 'Default'
              mavenAuthenticateFeed: false
              effectivePomSkip: false
              sonarQubeRunAnalysis: false    
# To Docker image build and push
  - stage: Docker_Build          
    displayName: 'Docker_Build'
    jobs:
      - job: docker_build
        displayName: 'docker_build'
        steps:
          - task: CmdLine@2
            inputs:
              script: 'mvn package'
          - task: Docker@2
            inputs:
               containerRegistry: 'docker-conn'  # Use service connection name for Docker task
               repository: '$(repository)'
               command: 'build'
               Dockerfile: '**/Dockerfile'
               tags: '$(imageTag)'
# Add Trivy Image scan .  
  - stage: Trivy_image_Scan
    displayName: 'Trivy_image_Scan'
    jobs:
      - job: Trivy_image_Scan
        displayName: 'Trivy image Scan'       
        steps:
          - task: CmdLine@2
            inputs:
              script: 'trivy image --format table -o trivy-image-report.html $(containerRegistry)/$(repository):$(imageTag)'
# To Docker push Image
  - stage: Docker_Publish          
    displayName: 'Docker_Publish'
    jobs:
      - job: docker_Publish
        displayName: 'docker_Publish'
        steps:
          - task: Docker@2
            inputs:
              containerRegistry: 'docker-conn'  # Use service connection name for Docker task
              repository: '$(repository)'
              command: 'push'
              tags: '$(imageTag)'

# To Update the manifest file
  - stage: Update_Manifest_file
    displayName: Update_Manifest_file
    jobs:
    - job: Update
      displayName: Update_Manifest_file
      steps:
      - script: |
          sudo apt-get update
          sudo apt-get install dos2unix -y
          dos2unix 'scripts/updateK8sManifests.sh'
        displayName: 'Install pkgs'
      - task: ShellScript@2
        inputs:  
          scriptPath: 'scripts/updateK8sManifests.sh'
          args: '$(containerRegistry) $(repository) $(imageTag) Service-deployment'

              
# To Deploy on K8s
  - stage: deploy_to_k8s
    displayName: 'Deploy to AKS'
    jobs:
      - job: deploy_to_k8s
        displayName: 'Deploy to AKS'
        steps:
           - task: KubernetesManifest@1
             inputs:
               action: 'deploy'
               connectionType: 'kubernetesServiceConnection'
               kubernetesServiceConnection: 'k8s-conn'
               namespace: 'default'
               manifests: 'k8s-specifications/Service-deployment.yaml'
           - script: |
               kubectl describe deployment bankapp --namespace default
               kubectl logs deployment/bankapp --namespace default
             displayName: 'Check Deployment Logs'
             continueOnError: true
```