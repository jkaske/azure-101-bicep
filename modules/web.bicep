// NOTE: you do NOT have to edit this file unless you wish to do custom configurations

var namePostfix = uniqueString(resourceGroup().id)

resource storage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'web${namePostfix}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

var origin = replace(replace(storage.properties.primaryEndpoints.web, 'https://', ''), '/', '')

resource cdn 'Microsoft.Cdn/profiles@2020-09-01' = {
  name: 'cdn${namePostfix}'
  location: resourceGroup().location
  sku: {
    name: 'Standard_Microsoft'
  }

  resource endpoint 'endpoints' = {
    name: 'endpoint${namePostfix}'
    location: resourceGroup().location
    properties: {
      originHostHeader: origin
      isHttpAllowed: false
      origins: [
        {
          name: 'storageOrigin'
          properties: {
            hostName: origin
          }
        }
      ]
    }
  }
}

// This resource configures static website hosting for the storage account
// To achieve this an Azure Container Instance is created that runs an Azure CLI script
// the container is deleted after the script is executed
// note that when performing this operation the '$web' container is created automatically
param utcValue string = utcNow()
resource enableStaticWebsite 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'enableStaticWebsite'
  location: resourceGroup().location
  kind: 'AzureCLI'
  properties: {
    forceUpdateTag: utcValue
    azCliVersion: '2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'P1D'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: storage.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        value: storage.listKeys().keys[0].value
        secureValue: 'true'
      }
    ]
    arguments: 'index.html'
    scriptContent: 'az storage blob service-properties update --static-website --index-document $1 --404-document $1 '
  }
}

var storageWebEndpoint = storage.properties.primaryEndpoints.web
var urlMinusTrailingSlash = take(storageWebEndpoint, length(storageWebEndpoint)-1)

output storageWebEndpoint string = urlMinusTrailingSlash
output cdnEndpoint string = 'https://${cdn::endpoint.properties.hostName}'
