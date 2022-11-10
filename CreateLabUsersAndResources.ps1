param (
    [Parameter( HelpMessage="Azure Subscription ID for the deployment.",
                Mandatory = $true)]
    [string]$SubscriptionId,
    [Parameter( HelpMessage="File path to the list of users to deploy",
                Mandatory=$true)]
    [string]$FilePath,
    [Parameter( HelpMessage="Group name to add all new users to.",
                Mandatory=$true)]
    [string]$GroupName,
    [Parameter( HelpMessage="Domain Name for the user UPN",
                Mandatory=$true)]
    [string]$DomainName,
    [Parameter( HelpMessage="Azure location for resource deployment",
                Mandatory=$true)]
    [string]$Location,
    [Parameter( HelpMessage="Managed Instance Server Name",
                Mandatory=$true)]
    [string]$DBMIName
)

Function Get-Password() {
    $CapitalPasswordSource = "ABCDEFGHJKMNPQRSTUVWXYZ".ToCharArray()
    $LowerCasePasswordSource = "ABCDEFGHJKMNPQRSTUVWXYZ".ToLower().ToCharArray()
    $NumberPasswordSource = "123456789".ToCharArray()
    $SpecialCharsPasswordSource = "!@#$%&".ToCharArray()
    $TempPassword += ($CapitalPasswordSource | Get-Random)
    For ($loop=2; $loop -le 14; $loop++) {
        $TempPassword+=($LowerCasePasswordSource | Get-Random)
    }
    $TempPassword += ($NumberPasswordSource | Get-Random)
    $TempPassword += ($NumberPasswordSource | Get-Random)
    $TempPassword += ($SpecialCharsPasswordSource | Get-Random)
    return $TempPassword
}

# Remember to document need for Connect-AzureAD before running script (can't be in script?)

Select-AzSubscription -SubscriptionId $SubscriptionId

$group = New-AzureAdGroup -Description "SQL Migration Lab Users" -DisplayName $GroupName -MailEnabled $false -SecurityEnabled $true -MailNickname $GroupName

$IntialDeploymentParameters = @{
    location = $Location
    bastionHostName = "csasqllabbastion"
    principalId = $group.ObjectId.ToString()
}

New-AzDeployment -Location $Location -TemplateFile single_subscription_initial_deployment.bicep -TemplateParameterObject $IntialDeploymentParameters

$SubNetOctet = 3

$users = New-Object -TypeName 'System.Collections.ArrayList'

ForEach ($user in Import-Csv $FilePath) {
    Write-Host "Starting Deployment for $($user.UserName)"
    $Password = Get-Password
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $Password
    $AADuser = New-AzureADUser -DisplayName $user.UserName -PasswordProfile $PasswordProfile -UserPrincipalName "$($user.UserName)@$DomainName" -AccountEnabled $true -MailNickName $user.UserName

    $UserDeploymentParameters = @{
        location = $Location
        rgName = "$($user.UserName)-SqlLab"
        administratorLogin = $user.UserName
        administratorLoginPassword = $Password
        vmSubnetPrefix = "10.217.$SubNetOctet.0/24"
        principalId = $AADuser.ObjectId.ToString()
        sqldb_aad_admin_name = $AADuser.UserPrincipalName
        sqldb_aad_admin_objectid = $AADuser.ObjectId.ToString()
        sqldb_aad_admin_type = "User"
    }
    New-AzDeployment -Location $Location -TemplateFile single_subscription_user_deployment.bicep -TemplateParameterObject $UserDeploymentParameters -AsJob -Name $(New-Guid).ToString()
    Add-AzureADGroupMember -ObjectId $group.ObjectId.ToString() -RefObjectId $AADuser.ObjectId.ToString()

    $users.Add(@{
        UserName = $AADuser.UserPrincipalName
        Password = $Password
    })
    $SubNetOctet++
}

Write-Host "All User deployments started, waiting on completion"

$users | ForEach-Object{[PSCustomObject]$_} | Format-Table

While ((Get-Job | Where-Object {$_.State -ne "Complete" -and $_.State -ne "Failed" -and $_.State -ne "Stopped"} | Measure-Object).Count > 0) {
    Get-AzDeployment
    Start-Sleep -Seconds 60
}

$MIPassword = Get-Password
$DBMIDeploymentParameters = @{
    managedInstanceName = $DBMIName
    administratorLogin = 'dbmisa'
    administratorLoginPassword = $MIPassword
    withAADAuth = $true
    aad_admin_name = $group.DisplayName
    aad_admin_objectid = $group.ObjectId.ToString()

}

New-AzResourceGroupDeployment -ResourceGroupName "SQLMigrationLab" -TemplateFile dbmi.bicep -TemplateParameterObject $DBMIDeploymentParameters -AsJob

Write-Host "DBMI Username: dbmisa"
Write-Host "DBMI Password: $MIPassword"

Write-Host "MI Deployment started, Monitor via the portal."