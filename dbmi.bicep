
@description('Location for all resources.')
param location string = resourceGroup().location

@description('Enter managed instance name.')
param managedInstanceName string

@description('Enter Managed Instance subnet name.')
param sqlMiSubnetName string = 'ManagedInstance'

@description('Enter user name, this will be your VM Login, SQL DB Admin, and SQL MI Admin')
param administratorLogin string

@description('Enter password, this will be your VM Password, SQL DB Admin Password, SQL MI Admin Password, and sa Password')
@secure()
@minLength(16)
param administratorLoginPassword string

@description('Enter sku name.')
@allowed([
  'GP_Gen5'
])
param skuName string = 'GP_Gen5'

@description('Enter number of vCores.')
@allowed([
  4
  8
  16
  24
  32
  40
  64
  80
])
param vCores int = 4

@description('Enter storage size.')
@minValue(32)
@maxValue(8192)
param storageSizeInGB int = 256

@description('Enter license type.')
@allowed([
  'BasePrice'
  'LicenseIncluded'
])
param licenseType string = 'LicenseIncluded'

param withAADAuth bool = false

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
param aad_admin_type string = 'Group'

@description('Enter virtual network name. If you leave this field blank name will be created by the template.')
param virtualNetworkName string = 'SQLMigrationLab-vNet'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: virtualNetworkName
}

resource managedInstance 'Microsoft.Sql/managedInstances@2021-11-01-preview' = {
  name: managedInstanceName
  location: location
  sku: {
    name: skuName
  }
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    virtualNetwork
  ]
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, sqlMiSubnetName)
    storageSizeInGB: storageSizeInGB
    vCores: vCores
    licenseType: licenseType
    administrators: (withAADAuth) ? {
      login: aad_admin_name
      sid: aad_admin_objectid
      tenantId: aad_admin_tenantid
      principalType: aad_admin_type
    } : null
  }
}
