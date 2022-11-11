

      # Define global variables for the script  
      $prefixName = '<a prefix name>'  # used as the prefix for the name for various objects  
      $subscriptionName= '<your subscription name>'   # the name of subscription name you will use  
      $locationName = '<a data center location>'  # the data center region you will use  
      $storageAccountName= '<storage account name>' # the storage account name you will use  
      $containerName= '<container name>'  # the storage container name to which you will attach the SAS policy with its SAS token  
      $policyName = 'saspolicyname' # the name of the SAS policy you will create

      # Set a variable for the name of the resource group you will use. Should be SQLMigrationLab but double check
      $resourceGroupName= 'SQLMigrationLab'

      # adds an authenticated Azure account for use in the session
      Connect-AzAccount

      # set the tenant, subscription and environment for use in the rest of
      Set-AzContext -SubscriptionName $subscriptionName

      # Get the access keys for the ARM storage account  
      $accountKeys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName  

      # Create a new storage account context using an ARM storage account  
      $storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $accountKeys[0].value 

      # Uses container in Azure Blob Storage  
      $cbc = $container.CloudBlobContainer  

      # Sets up a Stored Access Policy and a Shared Access Signature for the new container  
      $policy = New-AzStorageContainerStoredAccessPolicy -Container $containerName -Policy $policyName -Context $storageContext -ExpiryTime $(Get-Date).ToUniversalTime().AddYears(10) -Permission "rwld"
      $sas = New-AzStorageContainerSASToken -Policy $policyName -Context $storageContext -Container $containerName
      Write-Host 'Shared Access Signature= '$($sas.Substring(1))''  

      # Outputs the Transact SQL to the clipboard and to the screen to create the credential using the Shared Access Signature  
      Write-Host 'Credential T-SQL'  
      $tSql = "CREATE CREDENTIAL [{0}] WITH IDENTITY='Shared Access Signature', SECRET='{1}'" -f $cbc.Uri,$sas.Substring(1)   
      Write-Host $tSql

 
