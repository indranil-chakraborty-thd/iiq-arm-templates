# Azure Resource Manager Tutorial #2

In this tutorial, we will create and deploy a VM. The VM will have the following features:
* Based on a machine size offered by Azure (see [here](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general))
    * OS / Storage is as defined by the VM offering
* Networking configuration includes:
    * A public IP 
    * A user-defined networking subnet
    * Network security group configurations that creates firewall rules such that only SSH traffic on port 22 is permitted
* SSH service is enabled for key-based authentication; the 'root' user and key are user-specified
* All resources are prefixed with a user-defined value making the resources easy to identify

## Instructions
1. Download and install the Azure CLI.
2. Login to Azure
    ```shell script
    $> az login
    ```
3. List your existing subscriptions.
    ```shell script
    $> az account list --output table
    ```
4. Specify the subscription you wish to use. This step is optional if you already have a default subscription set.
    ```shell script
    $> az account set --subscription "ixc5ffg-free-sub-1"
    ```
5. Create the resource group from the template
    ```shell script
    $> az group create --name arm-vscode --location eastus
    ```
6. Update parameters file to specify the paramter values. Use below command to determine the VM offerings.
    ```shell script
    $> az vm image list --output table
    ```    
7. Validate the template
    ```shell script
    $> az deployment group validate --resource-group arm-vscode --template-file azuredeploy.json --parameters azuredeploy.parameters.json
    ```
8. Create the resources
    ```shell script
    $> az deployment group create --resource-group arm-vscode --template-file azuredeploy.json --parameters azuredeploy.parameters.json
    ```
9. Delete resources after use
    ```shell script
    $> az group delete --name arm-vscode

