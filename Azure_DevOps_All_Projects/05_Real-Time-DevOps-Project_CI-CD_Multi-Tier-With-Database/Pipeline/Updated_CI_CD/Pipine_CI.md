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
          azureSubscription: 'azure-conn'
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
              azureSubscription: 'azure-conn'
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
              azureSubscription: 'azure-conn'
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
               containerRegistry: 'docker-conn'
               repository: 'dev'
               command: 'build'
               Dockerfile: '**/Dockerfile'
               tags: 'latest'
# Add Trivy Image scan .  
  - stage: Trivy_image_Scan
    displayName: 'Trivy_image_Scan'
    jobs:
      - job: Trivy_image_Scan
        displayName: 'Trivy image Scan'       
        steps:
          - task: CmdLine@2
            inputs:
              script: 'trivy image --format table -o trivy-image-report.html aconreg05a01096.azurecr.io/dev:latest'
# To Docker push Image
  - stage: Docker_Publish          
    displayName: 'Docker_Publish'
    jobs:
      - job: docker_Publish
        displayName: 'docker_Publish'
        steps:
          - task: Docker@2
            inputs:
              containerRegistry: 'docker-conn'
              repository: 'dev'
              command: 'push'
              tags: 'latest'
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
```