param([string] $vaultname, [string] $vnetName)
# Get all the Subnets defined in the Vnet
$subnets = (Get-AzVirtualNetwork -Name $vnetName).Subnets
# Store the resource ids for each subnet in an ArrayList
$subnetIds = New-Object System.Collections.ArrayList
foreach ($subnet in $subnets) {
    $subnetIds.Add($subnet.id)
}
# Secure the vault by denying external access and permitting access from only the Vnet subnets
Update-AzKeyVaultNetworkRuleSet -VaultName $vaultname -DefaultAction Deny -Bypass AzureServices -PassThru -VirtualNetworkResourceId $subnetIds