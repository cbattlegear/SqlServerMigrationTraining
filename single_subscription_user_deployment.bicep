targetScope = 'subscription'

@description('Enter a resource group name.')
param rgName string = 'User-SQLMigrationLab'

@description('Enter the network resource group name.')
param networkRgName string = 'SQLMigrationLab'

@description('Choose a location')

param location string

@description('Default VM Size')
param vmSize string = 'Standard_E8s_v4'

@description('Enter the SQL DB Database name.')
param sqlDBDatabaseName string = 'SqlMigrationLab'

@description('Enter user name, this will be your VM Login, SQL DB Admin, and SQL MI Admin')
param administratorLogin string

@description('Enter password, this will be your VM Password, SQL DB Admin Password, SQL MI Admin Password, and sa Password')
@secure()
@minLength(16)
param administratorLoginPassword string

@description('Enter virtual network name. If you leave this field blank name will be created by the template.')
param virtualNetworkName string = 'SQLMigrationLab-vNet'

@description('Enter subnet address prefix.')
param vmSubnetPrefix string = '10.217.3.0/24'

@description('Object ID of the Assigned User')
param principalId string

@description('The name of the Azure AD admin for the SQL server.')
param sqldb_aad_admin_name string = 'none'

@description('The Object ID of the Azure AD admin.')
param sqldb_aad_admin_objectid string = 'none'

@description('The Tenant ID of the Azure Active Directory')
param sqldb_aad_admin_tenantid string = subscription().tenantId

@allowed([
  'User'
  'Group'
  'Application'
])
param sqldb_aad_admin_type string = 'Group'

var vmSubNetName = 'vmsub${uniqueString(rg.id)}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

resource networkRg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: networkRgName
}

@description('Add the Owner Role to the specific user')
module rbac 'single_subscription_permissions.bicep' = {
  scope: rg
  name: guid(rg.id, principalId)
  params: {
    principalId: principalId
    principalType: 'User'
    roleId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  }
}

module vmsubnet 'single_subscription_vm_subnet.bicep' = {
  name: 'vmSubnetDeployment'
  scope: networkRg
  params: {
    existingVNETName: virtualNetworkName
    newSubnetName: vmSubNetName
    newSubnetAddressPrefix: vmSubnetPrefix
  }
}

module labvm 'labvm.bicep' = {
  name: 'labVmDeployment'
  scope: rg
  params: {
    vmName: 'vm${uniqueString(rg.id)}'
    vmSize: vmSize
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    vmSubnetName: vmSubNetName
  }
  dependsOn: [
    vmsubnet
  ]
}

module sqldb 'sqldb.bicep' = {
  name: 'sqlDbDeployment'
  scope: rg
  params: {
    location: location
    sqlDBServerName: 'sql${uniqueString(rg.id)}'
    sqlDBDatabaseName: sqlDBDatabaseName
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    withAADAdmin: true
    aad_admin_name: sqldb_aad_admin_name
    aad_admin_objectid: sqldb_aad_admin_objectid
    aad_admin_tenantid: sqldb_aad_admin_tenantid
    aad_admin_type: sqldb_aad_admin_type
  }
}

module storage 'storage.bicep' = {
  name: 'storageAccountDeployment'
  scope: rg
  params: {
    location: location
  }
}
