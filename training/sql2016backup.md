# Migrate SQL Server 2016 to Azure SQL Managed Instance using TSQL Backup/Restore to/from URL - Offline

In this portion of the training you will be doing an assessment and offline migration of SQL Server 2016 using the TSQL method of back and restore to/from URL. You will backup the source database to an Azure Storage account. Before the backup and restore you are expected to do an assessment of the source database using the Database Migration Assistant (DMA). Verify there are no compatibility or feature parity issues. Address any issues prior to migration. 

Resources used and authentication: 
  - Azure SQL Server VM (Username/password)
    - SQL Server 2016 - AdventureWorks2016 (Windows Authentication)
  - Azure SQL MI (SQL Server Authentication - Same username/password) 
  - Azure Storage Account 

## Steps

1. Test connection to Azure SQL Managed Instance (MI) from SQL Server Management Studio (SSMS): 
   - Bastion into Azure SQL VM. 
   - Sign into Azure SQL MI through SSMS. 

2. Use Data Migration Assistant (DMA) to assess the source SQL Server 2016 database (AdventureWorks2016) to target Azure SQL MI:
   - Project Type = Assessment
   - Target Server type = Azure SQL Database Managed Instance
   
      **Note** - *Keep in mind the source database compatibility level as the run the assessment*
   - [Instructions to run assesment with DMA](https://learn.microsoft.com/en-us/sql/dma/dma-assesssqlonprem?view=sql-server-ver16#create-an-assessment)
   - Verify there are no feature parity or compatibility issues. Fix any issues before migrating the database.

3. 
