# Azure Resource Manager Tutorial 
A code sample based on the tutorial at https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/quickstart-create-templates-use-visual-studio-code?tabs=CLI

## Instructions
1. Download and install the Azure CLI.
2. Login to Azure
    ```shell script
    $> az login
    ```
3. List you existing subscriptions.
    ```shell script
    $> az account list --output table
    ```
4. Specify the subscription you wish to use unless you have a default already set.
    ```shell script
    $> az account set --subscription "ixc5ffg-free-sub-1"
    ```
5. Create the resource group from the template
    ```shell script
    $> az group create --name arm-vscode --location eastus
    ```
6. Validate the template
    ```shell script
    $> az deployment group validate --resource-group arm-vscode --template-file azuredeploy.json --parameters azuredeploy.parameters.json
    ```
7. Create the resources
    ```shell script
    $> az deployment group create --resource-group arm-vscode --template-file azuredeploy.json --parameters azuredeploy.parameters.json
    ```
8. Delete resources after use
    ```shell script
    $> az group delete --name arm-vscode
    ```
