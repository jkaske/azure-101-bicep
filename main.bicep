module web './modules/web.bicep' = {
  name: 'web-module-deployment'
}

module storage './modules/storage.bicep' = {
  name: 'storage-module-deployment'
}

module cosmos './modules/cosmos.bicep' = {
  name: 'cosmos-module-deployment'
}

module servicebus './modules/servicebus.bicep' = {
  name: 'servicebus-module-deployment'
}

module functionApp './modules/function-app.bicep' = {
  name: 'function-app-module-deployment'
  params: {
    corsUrls: [
      web.outputs.storageWebEndpoint
      web.outputs.cdnEndpoint
    ]

    // TODO: add application settings that your function app requires
    // - go through the local.settings.json file in your function app project to see which app settings you need
    // - check ./modules/function-app.bicep to see which app settings are provided automatically for you
    appSettings: [
      {
        name: 'STORAGE_CONNECTION_STRING'
        value: storage.outputs.connectionString
      }
      {
        name: 'jenskcosmos_DOCUMENTDB'
        value: cosmos.outputs.connectionStringAlternative
      }
      {
        name: 'jenskServiceBus_SERVICEBUS'
        value: servicebus.outputs.connectionString
      }
    ]
  }
}
