# Migrate SQL 2012 with Data Migration Assistant (DMA) - Offline

In this portion of the training you will be doing an assesment and offline migration of SQL Server 2012 using the Azure Data Migration Assistant (DMA). You are expected to review the assesment and validate that their are no SQL feature parity or compatability issues that are preventing a migration to Azure SQL DB. Address any issues prior to migrating. 

***NOTE*** - If you would like to assess the database and view and apply recommended fixes before migration, select the 'Assess database before migration?' checkbox option during the migration process.  

Resources used and authentication: 
  - Azure SQL Server VM (Username/password)
  - SQL Server 2012 - AdventureWorks2012 (Windows Authentication)
  - Azure SQL DB (SQL Server Authentication - Same username/password)
 
 ## Steps:
 
1. Test connection to Azure SQL DB from SQL SErver Management Studio (SSMS)
   - Bastion into Azure SQL VM. 
   - Sign into Azure SQL DB through SSMS. 




Supporting document: [Migrate SQL Server to Azure SQL DB using Data Migration Assistant](https://learn.microsoft.com/en-us/sql/dma/dma-migrateonpremsqltosqldb?view=sql-server-ver16)
