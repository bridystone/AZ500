Connect-AzAccount -AccountId az500breidenstein.info

$lab2_ressource_group = New-AzResourceGroup -Name AZ500Lab02 -Location 'eastus'

Get-AzResourceGroup | format-table


# Pick Policy Definition for later use
$allowed_locations = Get-AzPolicyDefinition -Builtin | 
    Where-Object {$_.Properties.Displayname -eq 'Allowed locations'}

# Hash of arrays as parameter
$allowed_locations_parameters = @{
    listOfAllowedLocations = @('uksouth')
}
$message = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implementation.Policy.PsNonComplianceMessage
$message.Message = "NOT IN UKSOUTH!!!!"

New-AzPolicyAssignment -Name 'Allowed locations' `
    -PolicyDefinition $allowed_locations `
    -PolicyParameterObject $allowed_locations_parameters `
    -Scope $lab2_ressource_group.ResourceId `
    -NonComplianceMessage $message

# Option with Parameter File
# New-AzPolicyAssignment -Name 'Allowed locations' `
#     -PolicyDefinition $allowed_locations `
#     -PolicyParameter .\allowed_locations.json `
#     -Scope $lab2_ressource_group.ResourceId

<#
# Remove All Policy Assignments
Get-AzPolicyAssignment -IncludeDescendent | ForEach-Object {Remove-AzPolicyAssignment -Id $_.PolicyAssignmentId }
#>

## !! Compliance Check -> Policy not yet active
# Requirement to wait for effectiveness
New-AzVirtualNetwork -Name "compliancetest" `
    -ResourceGroupName  (Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -eq "AZ500Lab02"}).ResourceGroupName `
    -Location "eastus" `
    -AddressPrefix "10.0.0.0/24"
    # -ResourceGroupName $lab2_ressource_group.ResourceGroupName `
