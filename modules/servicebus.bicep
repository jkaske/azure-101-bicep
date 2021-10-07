resource namespace 'Microsoft.ServiceBus/namespaces@2021-01-01-preview' = {
  name: 'sb-${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  resource auth 'AuthorizationRules' = {
    name: 'RootManageSharedAccessKey'
    properties: {
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
  }
  resource queue 'queues' = {
    name: 'thumbnailqueue'
  }
}

output connectionString string = namespace::auth.listKeys().primaryConnectionString
