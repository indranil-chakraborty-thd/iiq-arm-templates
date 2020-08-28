param([string] $vaultname)
Update-AzKeyVaultNetworkRuleSet -VaultName $vaultname -DefaultAction Deny -Bypass AzureServices -PassThru