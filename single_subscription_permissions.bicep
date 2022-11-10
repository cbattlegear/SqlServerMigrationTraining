@description('Object ID of the Assigned User/Group')
param principalId string

@description('Role Definition Id to assign the User/Group')
param roleId string

@allowed([
  'User'
  'Group'
  'Application'
])
param principalType string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, principalId, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleId))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleId)
    principalId: principalId
    principalType: principalType
  }
}
