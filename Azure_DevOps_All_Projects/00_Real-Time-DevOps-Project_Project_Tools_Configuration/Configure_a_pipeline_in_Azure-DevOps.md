
- #### <span style="color: Yellow;"> Create/Configure a pipeline in Azure DevOps.
  - Click on Pipeline:
   - follow the below instruction

- Click on pipeline and build it 
![image-15](https://github.com/user-attachments/assets/1569057a-b780-47fe-8272-236869de1a36)
![image-16](https://github.com/user-attachments/assets/b107209b-4d3e-4e0f-8fcd-969b61c43e15)
![image-8](https://github.com/user-attachments/assets/a3f02167-7b1e-46dd-8c66-7dadb0d7f4a1)
![image-18](https://github.com/user-attachments/assets/646a7063-9021-445f-9123-9be24ecd9c53)
    
  - It will ask you to log in with your Azure account. Please use the same login credentials that you have set up for the Azure portal.

  - Select the container registry
![image-7](https://github.com/user-attachments/assets/ebc5630e-d798-45d5-8688-2fe602defb3c)


  - **Note:** Key concept overview of pipeline.
![image-9](https://github.com/user-attachments/assets/2c902e33-4243-4171-a666-9d0eb5743120)


  - you will see the following pipeline yaml and we have to modify accordingly.
![image-8](https://github.com/user-attachments/assets/ab975781-a81a-41b7-bc2c-fa0686ac518b)

  - First, we will create a folder in the repo called 'scripts' and update the sh file as shown below. We will create a shell script to get an updated image tag if it is creating a new image.
![image-55](https://github.com/user-attachments/assets/43b96a06-d27c-46bf-b24a-1c0d7196f55a)
![image-80](https://github.com/user-attachments/assets/dd1b68b4-5e89-4f34-895f-1381eb513e9c)


  - Don't forget to update the container registroty name in the script file.
![image-23](https://github.com/user-attachments/assets/f74f2934-17d8-477a-a964-b725ab67e672)