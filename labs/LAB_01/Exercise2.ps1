Connect-AzureAD -AccountId az500@az500breidenstein.onmicrosoft.com

# get default domain name
$tennant = Get-AzureADTenantDetail
$domainname = $tennant.VerifiedDomains[0].Name

# create password profile
$password = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
Write-Host "Password: "
$password.Password = Read-Host -AsSecureString
$password.ForceChangePasswordNextLogin = $false

# add user
$isabel = New-AzureADUser `
    -DisplayName 'Isabel Garcia' `
    -AccountEnabled $true `
    -PasswordProfile $password `
    -MailNickName 'Isabel'`
    -UserPrincipalName ('isabel@' + $domainname)

Get-AzureADUser

# add new group 
$junior_admins = New-AzureADGroup -DisplayName "Junior Admins" -MailEnabled $false -MailNickName 'JuniorAdmins' -SecurityEnabled $true
Get-AzureADGroup

# add isabel to Junior Group
$user = Get-AzureADUser -Filter "MailNickName eq 'Isabel'"
Add-AzureADGroupMember -ObjectId $junior_admins.ObjectId -RefObjectId $user.ObjectId

Get-AzureADGroupMember -ObjectId $junior_admins.ObjectId