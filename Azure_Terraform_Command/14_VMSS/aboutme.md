I want to create a virtual machine scale set and I want to achieve as follows using all tf files. also write the output.tf files to show which resouce has been created by terraform. 
Please rewrite the whole tf files as per my requirement.

Virtual Machine Scale set name  : myfirst-demo-20012025
region: Australia
availibility zone: zone 1, Zone 2, Zone 3
orchestration mode : uniform
size: Standard_B1s
scaling mode : manually upgrade the capacity
instance count: 1
Azuthentication Type : SSH public key
username   : azureuser
ssh public key source: generate new key pair
keypair name : day_key

OS disk type : standard SSD
load balancing options : none

