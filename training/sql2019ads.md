# Migrate SQL 2019 to SQL Managed Instance with Azure Data Studio - Online

In this portion of the training you will be doing an assessment and online migration of SQL Server 2019 with Azure Data Studio. This module will cover an online migration scenario when minimal downtime is required. You will be performing the asssessment and migration of the SQL database with Azure Data Studio. If there are any compatibility or feature parity issues, address them prior to the migration. 

Resources used and authentication: 
  - Azure SQL Server VM (Username/password)
    - SQL Server 2019 - AdventureWorks2019 (Windows Authentication)
  - Azure SQL MI (Azure Active Directory) 
  - Azure Storage Account (SQL Server Credential will be created to authenticate) 

***NOTE*** - *Same Azure Storage Account will be used, but you will create a new container. You will also create a new SAS and SQL Credentails. Use the Azure Portal to create the SAS in this module*

## Steps

1. Test connection to Azure SQL Managed Instance (MI) from SQL Server Management Studio (SSMS): 
   - Bastion into Azure SQL VM. 
   - Sign into Azure SQL MI through SSMS. 

2. Create container for SQL Server database backup in the provided Azure Storage Account
    - Locate the Azure Storage Account created under the provisioned resource group (SQLMigrationLab).
    - Create a container with public access level set to private. Name it 'sqlbackup2019' (Can be any name).

3. Backup SQL Server 2019 -AdventureWorks 2019 database to URL (Azure Storage Account). 
   
    ***NOTE*** - *Use SSMS GUI to take database backup. Make sure you do Full backup to URL with CHECKSUM. Enable the CHECKSUM option before doing the credential on the backup database pane*
    
      *Reason for backup in this module: Azure Database Migration Service does not initiate any backups, and instead uses existing backups, which you may already have as part of your disaster recovery plan, for the migration.* 
    
    - [Create SQL Server Credential and backup database to URL via SSMS GUI](https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-sql-server-backup-and-restore-to-azure-blob-storage-service?view=sql-server-linux-ver16&tabs=SSMS#create-credential)

4. Use Azure Data Studio to assess and migrate SQL Server 2019 database (AdventureWorks2019) to Azure SQL MI. 
    - Open Azure SQL Data Studio and [install the Azure SQL Migration extension from the marketplace.](https://learn.microsoft.com/en-us/sql/azure-data-studio/extensions/azure-sql-migration-extension?view=sql-server-ver16#install-the-azure-sql-migration-extension)
    
    ***NOTE*** - *In the next set of instructions you are prompted to downlaod and install Microsoft Integration runttime, please skip. Not required for this module.*
    
    - [Follow these instructions to assess and migrate SQL Server.](https://learn.microsoft.com/en-us/azure/dms/tutorial-sql-server-managed-instance-online-ads#launch-the-migrate-to-azure-sql-wizard-in-azure-data-studio)

    - Once you start the live migration, you can [monitor the progress until the backups are restored to SQL MI.](https://learn.microsoft.com/en-us/azure/dms/tutorial-sql-server-managed-instance-online-ads#monitor-your-migration) The Migration status will show 'in progress' until you are ready to cut over. This is the only downtime that will occur during the process. 
    
    ***NOTE*** - In a live environment, transactions will continue to occur until all incoming traffic to the SQL Server is stopped. You will simulate this scenario in the next steps before completing the cutover. 
    
    - To simulate live transactions on the source database (SQL Server 2019 - AdventureWorks 2019) do the following edits to the following database tables: 
      - HumanResources.JobCandidate --> Add a column (HireFlag). Make it a bit data type. Allow Nulls. Update any 5 rows by setting HireFlag to 1. 
      - Production.ProductReview --> Insert 2 new reviews for Product ID 988 and  795 

    - [Complete the migration cutover.](https://learn.microsoft.com/en-us/azure/dms/tutorial-sql-server-managed-instance-online-ads#complete-migration-cutover)
      - [Instructions for tail-log backup.](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/back-up-the-transaction-log-when-the-database-is-damaged-sql-server?view=sql-server-ver15#SSMSProcedure)

5. Verify that the last transactions made before cutover reflect on the Azure SQL Managed Instance - AdventureWorks2019.
   

Great job! You just completed the second module! Move on the third module, [SQL Server 2012 => Offline migration - Microsoft Data Migration Assistant (DMA) migration to Azure SQL DB](/training/sql2012dma.md)



