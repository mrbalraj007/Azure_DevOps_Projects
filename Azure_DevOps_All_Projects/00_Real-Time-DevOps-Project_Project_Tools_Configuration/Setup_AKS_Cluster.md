### <span style="color: Yellow;">**Step-04: Setup AKS Cluster**</span>
  - Go Azure UI and select the AKS cluster 
  ![image-69](https://github.com/user-attachments/assets/72890d18-4698-4d12-864b-b61e493b02d1)
  ![image-70](https://github.com/user-attachments/assets/6b1ce124-10dc-4384-a370-add50bf1cce0)
  ![image-71](https://github.com/user-attachments/assets/61df9213-b7fc-4fbd-9e2b-dca92839e776)


  - Take a Putty session of the Azure VM and follow these instructions to log in to Azure and Kubernetes.

  - **Azure login**: Missing Browser on Headless Servers, Use the --use-device-code flag to authenticate without a browser:
    ```
    az login --use-device-code
    ```
    ![image-30](https://github.com/user-attachments/assets/c091888a-bcb3-4bfd-a726-aa4466225ff4)

  - https://microsoft.com/devicelogin Open this URL in a new browser and enter the code you see in the console..
![image-31](https://github.com/user-attachments/assets/1c2a3c10-a532-48e7-aafe-25230ced23b6)
![image-32](https://github.com/user-attachments/assets/ef18f082-e414-4030-83ed-a80baffffc57)

  - To list out all the account
  ```sh
  az account list --output table
  ```
  ![image-33](https://github.com/user-attachments/assets/32d77aa4-6bb6-4c2f-920b-2b1fd14a10b9)

  - To get resource details
  ```sh
  az aks list --resource-group "resourceGroupName" --output table
  ```
  ![image-34](https://github.com/user-attachments/assets/15c66017-5b79-4cfe-b3fe-603b2a4197aa)
  ![image-35](https://github.com/user-attachments/assets/081e2c85-4c47-4ff8-bfc7-fefcacd476b6)

  - [x] <span style="color: brown;"> Verify the AKS cluster.
  - To get credentails for AKS
  ```sh
  az aks get-credentials --name "Clustername" --resource-group "ResourceGroupName" --overwrite-existing

  kubectl config current-context
  kubectl get nodes
  kubectl get nodes -o wide
  ```
  ![image-36](https://github.com/user-attachments/assets/84252f38-7754-4bb9-bd2d-5eca24d34fa5)
