resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2021-06-15' = {
  name: 'cosmos-${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: resourceGroup().location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

// TODO: add a resource of type Microsoft.DocumentDB/databaseAccounts/sqlDatabases
//       - make sure to give the database the name that your function app expects
//         (i.e. if you have hardcoded the name in your function app you need to set the same name for the database here)

// TODO: add a resource of type Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers
//       - make sure to give the container the name that your function app expects
//         (i.e. if you have hardcoded the name in your function app you need to set the same name for the container here)

// TODO: add an output for the connection string of the Cosmos DB account
//       - hint: use listConnectionStrings() https://docs.microsoft.com/azure/azure-resource-manager/bicep/bicep-functions-resource#list
