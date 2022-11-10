# Migrate SQL Server 2016 to Azure SQL Managed Instance using T-SQL Backup/Restore to/from URL - Offline

In this portion of the training you will be doing an assessment and offline migration of SQL Server 2016 using the T-SQL method of back and restore to/from URL. You will backup the source database to an Azure Storage account. Before the backup and restore you are expected to do an assessment of the source database using the Database Migration Assistant (DMA). Verify there are no compatibility or feature parity issues. Address any issues prior to migration. 

**Note** - *There is a method to do this entire process through a GUI, but in this module you will do it programatically with T-SQL and a some PowerShell (Azure Cloud Shell)*

Resources used and authentication: 
  - Azure SQL Server VM (Username/password)
    - SQL Server 2016 - AdventureWorks2016 (Windows Authentication)
  - Azure SQL MI (SQL Server Authentication - Same username/password) 
  - Azure Storage Account (SQL Server Credential will be created to authenticate) 

## Steps

1. Test connection to Azure SQL Managed Instance (MI) from SQL Server Management Studio (SSMS): 
   - Bastion into Azure SQL VM. 
   - Sign into Azure SQL MI through SSMS. 

2. Use Data Migration Assistant (DMA) to assess the source SQL Server 2016 database (AdventureWorks2016) to target Azure SQL MI:
   - Project Type = Assessment
   - Target Server type = Azure SQL Database Managed Instance
   
      **Note** - *Keep in mind the source database compatibility level as you the run the assessment.*
   - [Instructions to run assesment with DMA.](https://learn.microsoft.com/en-us/sql/dma/dma-assesssqlonprem?view=sql-server-ver16#create-an-assessment)
   - Verify there are no feature parity or compatibility issues. Fix any issues before migrating the database.

3. Create container for SQL Server database backup in the provided Azure Storage Account
    - Locate the Azure Storage Account created under the provisioned resource group (SQLMigrationLab).
    - [Create a container with public access level set to private.](https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-sql-server-backup-and-restore-to-azure-blob-storage-service?view=sql-server-ver16&tabs=SSMS#create-azure-blob-storage-container) Name it 'sqlbackup' (Can be any name). 
    
4. T-SQL Backup SQL Server 2016 - AdventureWorks2016 database to URL (Azure Storage Account):
    - Open SSMS and login to the SQL Server 2016. 
    - First step of the backup is to have a container to upload the .bak file (already completed in step 3). 
    - In order to authenticate to the Azure Storage container, you require a SQL Server credential that will include a shared access signature (SAS) for the storage container. 
    - Create the SAS to your storage container first. The PowerShell script below will create and output the SAS that will be used in the next step. Copy and paste the below script to a text editor. Modify the variables according to your resource names. 

    ```powershell
    ```




    - 
    - 
    - [Create a SQL Server Credential](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url?view=sql-server-ver16#credential)    









*Keep in mind the compatibility level and name of the source database and the target database. For this module the target database was predeployed with a different name and compatibility level (150). Ideally these would be configured beforehand. You can change the name of the target database at the end of this module.*

 Verify that the schema and data migrated to the target database (Azure SQL DB): 
    - Use SSMS to login to the Azure SQL DB instance. 
    - Run a simple query against any table and verify records have populated. Compare against source database. 
    - [Check compatibility level of the Azure SQL DB instance.](https://learn.microsoft.com/en-us/sql/relational-databases/databases/view-or-change-the-compatibility-level-of-a-database?view=sql-server-ver16#TsqlProcedure) 
    - Optional: [Change the Azure SQL Database name to match the source database name.](https://learn.microsoft.com/en-us/sql/relational-databases/databases/rename-a-database?view=sql-server-ver16#to-rename-an-azure-sql-database-database
