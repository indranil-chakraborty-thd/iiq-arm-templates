# Azure Resource Manager Tutorial #6

In this tutorial, we will start tying things together. We will:
1. Create a Key Vault and add secrets required for our deployment using an ARM template.
2. Populate the vault with the secrets that we expect to use later in our deployment. These include:
    1. A user-specified GitHub Personal Access Token that can retrieve template JSON resources as specified through a URI.
    2. An auto-generated database password that is used as the administrator credential when creating the Azure SQL instance.
3. Split our template into distinct resource categories, including:
    1. Template for all shared resources
    2. Template for all VM resources
    3. Template for database resources

We are now making our template build modular so it becomes easier to understand, extend and maintain. See [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates#linked-template) for more information.

When this template deployment completes, you will have and environment with:
* A RHEL-7 VM with Java and Tomcat installed
* An instance of Azure SQL with the `identityiq` and `identityiqPlugin` databases created (but no tables created)


## Instructions

Review the `azuredeploy.paramters.json` file to make any changes such as changing the version  Java / Tomcat.

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
6. Set the project name variable in the `deployKeyVault.parameters.json` file.
7. Validate the template to create the key vault.
    ```shell script
    $> az deployment group validate --resource-group arm-vscode --template-file deployKeyVault.json --parameters deployKeyVault.parameters.json
    ```
8. Create the key vault with the secrets. 
    * The password for the SQL Administrator is auto-generated using a function that depends on the UTC timestamp of when the deployment is performed. 
    * The user is prompted for the GitHub Personal Access Token. Note that the PAT must have `repo` scope.

    ```shell script
    $> az deployment group create --resource-group arm-vscode --template-file deployKeyVault.json --parameters deployKeyVault.parameters.json
    ```
9. Secure the vault immediately to restrict access to only a specific IP. This should be set to the IP of the system from which the deployment is being run.
    ```shell script
    $> az keyvault update --name <vault-name> --default-action Deny
    $> az keyvault network-rule add --name <vault-name> --ip-address <client-ip>
    ```

### Other helpful tips
1. Key Vault by default is soft deleted and so you won't be able to create another key vault with the same name until it is purged post retention period. To purge immediately, run `az keyvault purge --name <vault-name>`. 