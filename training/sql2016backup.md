# Migrate SQL Server 2016 to Azure SQL Managed Instance using T-SQL Backup/Restore to/from URL - Offline

In this portion of the training you will be doing an assessment and offline migration of SQL Server 2016 using the T-SQL method of back and restore to/from URL. You will back up the source database to an Azure Storage account. Before the backup and restore you are expected to do an assessment of the source database using the Database Migration Assistant (DMA). Verify there are no compatibility or feature parity issues. Address any issues prior to migration. 

**Note** - *There is a method to do this entire process through a GUI, but in this module you will do it programmatically with T-SQL and a some PowerShell (Azure Cloud Shell)*

Resources used and authentication: 
  - Azure SQL Server VM (Username/password)
    - SQL Server 2016 - AdventureWorks2016 (Windows Authentication)
  - Azure SQL MI (Azure Active Directory) 
  - Azure Storage Account (SQL Server Credential will be created to authenticate) 

## Steps

1. Test connection to Azure SQL Managed Instance (MI) from SQL Server Management Studio (SSMS): 
   - Bastion into Azure SQL VM. 
   - Sign into Azure SQL MI through SSMS. 

2. Use Data Migration Assistant (DMA) to assess the source SQL Server 2016 database (AdventureWorks2016) to target Azure SQL MI:
   - Project Type = Assessment
   - Target Server type = Azure SQL Database Managed Instance
   
      **Note** - *Keep in mind the source database compatibility level as you the run the assessment.*
   - [Instructions to run assessment with DMA.](https://learn.microsoft.com/en-us/sql/dma/dma-assesssqlonprem?view=sql-server-ver16#create-an-assessment)
   - Verify there are no feature parity or compatibility issues. Fix any issues before migrating the database.

3. Create container for SQL Server database backup in the provided Azure Storage Account
    - Locate the Azure Storage Account created under the provisioned resource group (SQLMigrationLab).
    - [Create a container with public access level set to private.](https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-sql-server-backup-and-restore-to-azure-blob-storage-service?view=sql-server-ver16&tabs=SSMS#create-azure-blob-storage-container) Name it 'sqlbackup2016' (Can be any name). 
    
4. T-SQL Backup SQL Server 2016 - AdventureWorks2016 database to URL (Azure Storage Account):
    - Open SSMS and login to the SQL Server 2016. 
    - First step of the backup is to have a container to upload the .bak file (already completed in step 3). 
    - In order to authenticate to the Azure Storage container, you require a SQL Server credential that will include a shared access signature (SAS) for the storage container. 
    - Create the SAS to your storage container first. The PowerShell script below will create and output the T-SQL 'CREATE CREDENTIAL' with the SAS that will be used in the next step. Copy and paste the below script to a text editor. Modify the variables according to your resource names. Open Azure Cloud Shell and execute in PowerShell mode. Copy and save the T-SQL 'CREATE CREDENTIAL' output for the next step.  

      ![Use this PowerShell script to create a Shared Access Signature to the Storage Account](/training/PS_CreateSAS_Storage.ps1)
      
      
    - [Create a SQL Server Credential using the Shared Access Signature.](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url?view=sql-server-ver16#credential)    

      ***Note*** - *You will only use the SAS step. DO NOT use the account identity and access key. Make sure you integrate the previous PowerShell T-SQL output into this create credential script and replace resource names accordingly.*


     - [Perform a full database backup to URL.](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url?view=sql-server-ver16#complete) Only use the first step with SAS and include the 'WITH CHECKSUM' option after the URL string.  

5. T-SQL Restore from URL to Azure SQL MI.
    - Connect to the Azure SQL MI instance from SSMS. 
    - You need to create a SQL Server Credential on the SQL MI as well to access the storage container with SAS. Luckily you already have the T-SQL. Open a new query on the Azure SQL MI and execute the same CREATE CREDENTIAL T-SQL script that contains the SAS. 
    - [Now run the restore from URL T-SQL script.](https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-sql-server-backup-and-restore-to-azure-blob-storage-service?view=sql-server-ver16&tabs=tsql#restore-database) DO NOT forget to change the restore database name. 

6. Verify that the AdventureWorks2016 database was properly restored on the target database (Azure SQL MI): 
    - If the name of database is different, you did not change it in last step. Therefore [you can change it](https://learn.microsoft.com/en-us/sql/relational-databases/databases/rename-a-database?view=sql-server-ver16#to-rename-an-azure-sql-database-database) or rerun the restore with correct database name. 
    - Run a simple query against any table and verify tables have populated. Compare against source database. 
    - [Check compatibility level of the Azure SQL DB instance.](https://learn.microsoft.com/en-us/sql/relational-databases/databases/view-or-change-the-compatibility-level-of-a-database?view=sql-server-ver16#TsqlProcedure) Make sure it is set to 150. [Change the compatibility level of database](https://learn.microsoft.com/en-us/sql/relational-databases/databases/view-or-change-the-compatibility-level-of-a-database?view=sql-server-ver16#change-the-compatibility-level-of-a-database) and verify again. 
    
Great job, you just completed the first module! Move on the second module, [SQL Server 2019 => Online migration - Azure Data Studio migration to Azure SQL MI](/training/sql2019ads.md)
