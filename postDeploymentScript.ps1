param([string] $vaultname, [string] $vnetName)

Update-AzKeyVaultNetworkRuleSet -VaultName $vaultname -DefaultAction Deny -Bypass AzureServices -PassThru

$subnets = (Get-AzVirtualNetwork -Name $vnetName).Subnets

foreach ($subnet in $subnets) {
    Update-AzKeyVaultNetworkRuleSet -VaultName $vaultname -VirtualNetworkResourceId $subnet.id
}
