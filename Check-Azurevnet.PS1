# Check-Azurevnet.PS1
# Script to list all Virtual Networks in a specified Azure Resource Group

param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName
)

# Connect to Azure account if not already connected
if (-not (Get-AzContext)) {
    Connect-AzAccount
}

# Get all VNets in the specified resource group
$vnets = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName

if ($vnets) {
    Write-Host "Virtual Networks in Resource Group '$ResourceGroupName':" -ForegroundColor Green
    $vnets | Select-Object Name, Location, AddressSpace | Format-Table -AutoSize
} else {
    Write-Host "No Virtual Networks found in Resource Group '$ResourceGroupName'." -ForegroundColor Yellow
}