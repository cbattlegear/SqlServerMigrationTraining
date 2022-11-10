# Migrate SQL 2019 to SQL Managed Instance with Azure Data Studio - Online

In this portion of the training you will be doing an assessment and online migration of SQL Server 2019 with Azure Data Studio. This module will cover an online migration scenario when minimal downtime is required. You will be performing the asssessment and migration of the SQL database with Azure Data Studio. If there are any compatibility or feature parity issues, address them prior to the migration. 

Resources used and authentication: 
  - Azure SQL Server VM (Username/password)
    - SQL Server 2019 - AdventureWorks2019 (Windows Authentication)
  - Azure SQL MI (SQL Server Authentication - Same username/password) 
  - Azure Storage Account (SQL Server Credential will be created to authenticate) 

***NOTE*** - *Same Azure Storage Account will be used, but you will create a new container. You will also create a new SAS and SQL Credentails. Use the Azure Portal to create the SAS in this module*

## Steps

1. Test connection to Azure SQL Managed Instance (MI) from SQL Server Management Studio (SSMS): 
   - Bastion into Azure SQL VM. 
   - Sign into Azure SQL MI through SSMS. 

2. Create container for SQL Server database backup in the provided Azure Storage Account
    - Locate the Azure Storage Account created under the provisioned resource group (SQLMigrationLab).
    - Create a container with public access level set to private. Name it 'sqlbackup2019' (Can be any name).

3. 

4. Use Azure Data Studio to assess and migrate SQL Server 2019 database (AdventureWorks2019) to Azure SQL MI. 
    - Open Azure SQL Data Studio and [install the Azure SQL Migration extension from the marketplace.](https://learn.microsoft.com/en-us/sql/azure-data-studio/extensions/azure-sql-migration-extension?view=sql-server-ver16#install-the-azure-sql-migration-extension)
    
    - [Follow these instructions to assess and migrate SQL Server.](https://learn.microsoft.com/en-us/azure/dms/tutorial-sql-server-managed-instance-online-ads#launch-the-migrate-to-azure-sql-wizard-in-azure-data-studio)


Great job, you just completed the second module! Move on the third module, [SQL Server 2012 => Offline migration - Microsoft Data Migration Assistant (DMA) migration to Azure SQL DB](/training/sql2012dma.md)



