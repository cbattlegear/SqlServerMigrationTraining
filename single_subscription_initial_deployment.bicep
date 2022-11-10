targetScope = 'subscription'

@description('Enter a resource group name.')
param rgName string = 'SQLMigrationLab'

@description('Choose a location')

param location string

@description('Enter virtual network name. If you leave this field blank name will be created by the template.')
param virtualNetworkName string = 'SQLMigrationLab-vNet'

@description('Enter virtual network address prefix.')
param addressPrefix string = '10.217.0.0/16'

@description('Enter the Bastion host name.')
param bastionHostName string

@description('Bastion subnet IP prefix MUST be within vnet IP prefix address space')
param bastionSubnetIpPrefix string = '10.217.2.0/24'

@description('Enter Managed Instance subnet name.')
param sqlMiSubnetName string = 'ManagedInstance'

@description('Enter subnet address prefix.')
param sqlMiSubnetPrefix string = '10.217.1.0/24'

@description('Object ID of the user or group to give reader permission')
param principalId string

@allowed([
  'User'
  'Group'
  'Application'
])
param principalType string = 'Group'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

@description('Add the Reader Role to the specific user/group')
module rbac 'single_subscription_permissions.bicep' = {
  scope: rg
  name: guid(rg.id, principalId)
  params: {
    principalId: principalId
    principalType: principalType
    roleId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  }
}

module network 'network.bicep' = {
  name: 'labNetworkDeployment'
  scope: rg
  params: {
    location: location
    virtualNetworkName: virtualNetworkName
    addressPrefix: addressPrefix
    bastionSubnetIpPrefix: bastionSubnetIpPrefix
    sqlMiSubnetName: sqlMiSubnetName
    sqlMiSubnetPrefix: sqlMiSubnetPrefix
    bastionHostName: bastionHostName
  }
}
