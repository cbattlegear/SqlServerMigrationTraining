@description('Location for all resources.')
param location string = resourceGroup().location

@description('Enter the SQL DB Logical Server name.')
param sqlDBServerName string

@description('Enter the SQL DB Database name.')
param sqlDBDatabaseName string

@description('Enter user name, this will be your VM Login, SQL DB Admin, and SQL MI Admin')
param administratorLogin string

@description('Enter password, this will be your VM Password, SQL DB Admin Password, SQL MI Admin Password, and sa Password')
@secure()
@minLength(12)
param administratorLoginPassword string

param withAADAdmin bool = false

@description('The name of the Azure AD admin for the SQL server.')
param aad_admin_name string = 'none'

@description('The Object ID of the Azure AD admin.')
param aad_admin_objectid string = 'none'

@description('The Tenant ID of the Azure Active Directory')
param aad_admin_tenantid string = subscription().tenantId

@allowed([
  'User'
  'Group'
  'Application'
])
param aad_admin_type string = 'User'

resource sqlServer'Microsoft.Sql/servers@2021-08-01-preview' =  {
  name: sqlDBServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    administrators: (withAADAdmin) ? {
      login: aad_admin_name
      sid: aad_admin_objectid
      tenantId: aad_admin_tenantid
      principalType: aad_admin_type
    } : null
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2021-08-01-preview' = {
  parent: sqlServer
  name: sqlDBDatabaseName
  location: location
  sku: {
    name: 'GP_Gen5'
    tier: 'GeneralPurpose'
    capacity: 2
  }
}
