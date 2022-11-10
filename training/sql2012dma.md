# Migrate SQL Server 2012 to Azure SQL DB with Data Migration Assistant (DMA) - Offline

In this portion of the training you will be doing an assessment and offline migration of SQL Server 2012 using the Azure Data Migration Assistant (DMA). You are expected to review the assessment and validate that there are no SQL feature parity or compatibility issues that are preventing a migration to Azure SQL DB. Address any issues prior to migrating. 

Resources used and authentication: 
  - Azure SQL Server VM (Username/password)
    - SQL Server 2012 - AdventureWorks2012 (Windows Authentication)
  - Azure SQL DB (SQL Server Authentication - Same username/password)
 
 ## Steps:
 
1. Test connection to Azure SQL DB from SQL Server Management Studio (SSMS):
   - Bastion into Azure SQL VM. 
   - Sign into Azure SQL DB through SSMS. 
      
      **Note** - *You will run into a firewall rule prompt. DO NOT add the rule through here. Add the Azure SQL DB firewall rule through the Azure Portal. The client (Azure SQL VM) IP Address needs to be explicitly added in order to establish a connection.* 

2. Use DMA to assess and migrate SQL Server 2012 database (Adventureworks2012) to Azure SQL DB:
      
      **Note** - *Do the assessment and migration in one step. There is an option available to do the assessment and view/apply recommended fixes before migrating. The option will be available after you create and select the 'Migration' project type. To use this option, select the 'Access database before migration?' check box.* 
      
      ![image](https://user-images.githubusercontent.com/53837525/201004994-0abcccdd-3519-45db-840e-71369416385d.png)
      
      *Keep in mind the compatibility level and name of the source database and the target database. For this module the target database was predeployed with a different name and compatibility level (150). Ideally these would be configured beforehand. You can change the name of the target database at the end of this module.*
      
      *We will not be migrating the source database users in this module, only moving the schema and data.*
      
      - Follow these instructions: [Migrate SQL Server to Azure SQL DB using Data Migration Assistant](https://learn.microsoft.com/en-us/sql/dma/dma-migrateonpremsqltosqldb?view=sql-server-ver16)

3. Verify that the schema and data migrated to the target database (Azure SQL DB): 
    - Use SSMS to login to the Azure SQL DB instance. 
    - Run a simple query against any table and verify records have populated. Compare against source database. 
    - Check compatability level of the Azure SQL DB instance. 
    - Optional: Change the Azure SQL Database name to match the source database name. 


