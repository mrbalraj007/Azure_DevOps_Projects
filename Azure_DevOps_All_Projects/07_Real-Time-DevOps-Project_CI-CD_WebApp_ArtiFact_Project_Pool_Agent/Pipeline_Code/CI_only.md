```sh
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- main

pool:
  name: nike-website-pool

stages:
  - stage: Build
    jobs:
    - job: Build
      steps:
      - task: Npm@1
        inputs:
          command: 'custom'
          customCommand: 'install -D tailwindcss postcss autoprefixer'
      - task: Npm@1
        inputs:
          command: 'custom'
          customCommand: 'run build'
      - task: Npm@1
        inputs:
          command: 'publish'
          workingDir: './dist'
          publishRegistry: 'useFeed'
          publishFeed: 'c420a86b-fd1f-4e29-90eb-17d488d300b6/d00f33c5-ab18-4698-8ce1-39601d6af518'
```