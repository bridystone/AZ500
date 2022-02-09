Connect-AzAccount -AccountId az500breidenstein.info

# Create Storage Account
New-AzResourceGroup -Name "AZ500LAB03" -Location "eastus"

New-AzStorageAccount -ResourceGroupName "az500lab03" `
    -Name (Get-Random -Maximum 999999999999999) `
    -Location "eastus" `
    -Kind StorageV2 `
    -SkuName Standard_LRS


    # Create Lock
New-AzResourceLock -LockName "AZ500 Read only lock" `
    -LockLevel ReadOnly -ResourceGroupName "AZ500LAB03" -Force

# change data --> FAILS!
$storage = Get-AzStorageAccount -ResourceGroupName "AZ500LAB03"
Set-AzStorageAccount -Name $storage.StorageAccountName `
    -ResourceGroupName "AZ500LAB03" `
    -EnableHttpsTrafficOnly $false
# ==> FAILURE after wait

# Remove Lock
$locks = Get-AzResourceLock -LockName "AZ500 Read only lock" -ResourceGroupName "AZ500LAB03"
Remove-AzResourceLock -LockId $locks.LockId -Force



# Create Lock
New-AzResourceLock -LockName "AZ500 Delete lock" `
    -LockLevel "CanNotDelete" -ResourceGroupName "AZ500LAB03" -Force

# CHANGE -> Works
$storage = Get-AzStorageAccount -ResourceGroupName "AZ500LAB03"
Set-AzStorageAccount -Name $storage.StorageAccountName `
    -ResourceGroupName "AZ500LAB03" `
    -EnableHttpsTrafficOnly $false

Remove-AzStorageAccount -Name $storage.StorageAccountName `
-ResourceGroupName "AZ500LAB03" -Force
# DELETE -> Fails
# @(Get-AzResourceLock -LockName "AZ500 Delete lock" -ResourceGroupName "AZ500LAB03").Count
# while (@(Get-AzResourceLock -LockName "AZ500 Delete lock" -ResourceGroupName "AZ500LAB03").Count -eq 0) {
#     Write-Host "Waiting for provisioning"
#     Start-Sleep -Seconds 1
# }
# @(Get-AzResourceLock -LockName "AZ500 Delete lock" -ResourceGroupName "AZ500LAB03").Count

$locks = Get-AzResourceLock -LockName "AZ500 Delete lock" -ResourceGroupName "AZ500LAB03"
Remove-AzResourceLock -LockId $locks.LockId -Force
    
Remove-AzStorageAccount -Name $storage.StorageAccountName `
-ResourceGroupName "AZ500LAB03" -Force

# Cleanup
Remove-AzResourceGroup -Name "AZ500LAB03" -Force -AsJob