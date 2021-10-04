// TODO: add a resource of type Microsoft.Storage/storageAccounts
//       - make sure to give the storage account the name that your function app expects
//         i.e. if you have hardcoded the name in your function app you need to set the same name for the account here
//         note that the name has to be globally unique, so you might have to delete your old account!

// TODO: add a resource of type Microsoft.Storage/storageAccounts/blobServices/containers
//       - give it a name of 'images'

// TODO: add a resource of type Microsoft.Storage/storageAccounts/blobServices/containers
//       - give it a name of 'thumbnails'

// TODO: add an output for the connection string of the storage account
//       - hint: use listKeys() https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-resource#list
//       - a connection string has the following format
//         'DefaultEndpointsProtocol=https;AccountName=<ACCOUNT NAME>;AccountKey=<ACCOUNT KEY>;EndpointSuffix=core.windows.net'
