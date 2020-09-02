# Azure Resource Manager Tutorial #6

In this tutorial, we will start tying things together. We will:
1. Create a Key Vault and add a (pseudo)random password as a secret to be used as the SQL Server administrative password.
2. Split our template into distinct resource categories such as key vault, networking, SQL Server, databases, bastion host and VM.

We are now making our template build modular so it becomes easier to understand, extend and maintain. See [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates#linked-template) for more information.

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
6. Create the project resources.

    ```shell script
    $> az deployment group create --resource-group arm-vscode --template-file .\azuredeploy.json
    ```
9. Secure the vault immediately to restrict access to only a specific IP. 
    ```shell script
    $> az keyvault update --name <vault-name> --default-action Deny
    $> az keyvault network-rule add --name <vault-name> --ip-address <client-ip>
    ```

### Other helpful tips
1. Key Vault by default is soft deleted and so you won't be able to create another key vault with the same name until it is purged post retention period. To purge immediately, run `az keyvault purge --name <vault-name>`. 