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

resource thisRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: resourceGroup()
  name: roleId
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, principalId, thisRoleDefinition.id)
  properties: {
    roleDefinitionId: thisRoleDefinition.id
    principalId: principalId
    principalType: principalType
  }
}
