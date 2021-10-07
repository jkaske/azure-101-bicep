param skuName string = 'Standard_LRS'

var randomString = uniqueString(resourceGroup().id)

resource storage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'storage${randomString}'
  location: resourceGroup().location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'

  resource blobService 'blobServices' = {
    name: 'default'
    resource imageContainer 'containers' = {
      name: 'images'
      properties: {
        publicAccess: 'Blob'
      }
    }
    resource thumbnailContainer 'containers' = {
      name: 'thumbnails'
      properties: {
        publicAccess: 'Blob'
      }
    }
  }
}

var endpointSuffix = environment().suffixes.storage
output storageAccountName string = storage.name
output connectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${storage.listKeys().keys[0].value};EndpointSuffix=${endpointSuffix}'
