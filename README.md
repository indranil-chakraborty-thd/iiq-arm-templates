# Azure Resource Manager Tutorial #5

In this tutorial, we take a slight deviation where we will introduce Azure Key Vault as a means for storing secrets. The intent here is to prevent the storage of secrets such as a Database password, etc. that is required when deploying a template and instead using a Key Vault. This tutorial is taken from the one at https://docs.microsoft.com/en-us/azure/key-vault/secrets/quick-create-template?tabs=CLI

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

### Post deployment
Post deployment, the following commands should be run to secure the vault. These operations cannot currently be performed within the template.


1. Ensure that the vault is not accessible by default.

    ```shell script
    $> az keyvault update --name ixc5ffg-sandbox-vault --default-action Deny
    ```

2. Restrict access to any specific IP address / subnet. See sample below.

    ```shell script
    $> az keyvault network-rule add --name ixc5ffg-sandbox-vault --ip-address 136.49.135.154/32 --resource-group arm-vscode --subnet default --vnet-name ixc5ffg-sandbox-vnet
    ```
----

Note: Azure documentation [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template?tabs=CLI) indicates that one can use use a Deployment Script to run a post-deployment PowerShell or AZ CLI command/script. However, that involves using a Managed Identity that requires the 'Contributor' role on the subscription. Creating the managed identity and assigning it the Contributor role requires it to be assigned the ServicePrincipal as documented [here](https://docs.microsoft.com/bs-latn-ba/azure/role-based-access-control/role-assignments-template#new-service-principal) or one runs into the timing issue documented [here](https://github.com/Azure/azure-powershell/issues/2286). After overcoming these issues, I ran into an error stating that my Managed Identity did not have the authorization to perform the `Microsoft.ContainerInstance/register/action`, which lead me to read the Limitations as described [here](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-managed-identity). At this point, I gave up and decided it would be easier to simply run an AZ CLI command to secure the vault. 