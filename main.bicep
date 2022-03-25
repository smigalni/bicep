param appServicePlanName string = 'BicepIsTheBest'
param appServiceName string = 'BicepIsTheBest'
param skuName string = 'F1'
param skuTier string = 'Free'
param staticWebAppName string = 'BicepIsTheBest'
param appServiceTags object
param insightsTags object
param staticWebAppTags object

var location = resourceGroup().location 

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location 
  sku: {
    name: skuName
    tier: skuTier
  } 
}

resource insights 'Microsoft.Insights/components@2020-02-02' = {
  name: appServicePlanName
  location: location
  kind: 'web'
  tags: insightsTags
  properties: {
      Application_Type: 'web'
  }
}

resource appService 'Microsoft.Web/sites@2021-03-01' = {
  name: appServiceName
  location: location
  tags: appServiceTags
  dependsOn: [
    appServicePlan
  ]
  properties: {
    siteConfig: {
        appSettings: [
            { 
                name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
                value: insights.properties.InstrumentationKey
            }
            {
              name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value: 'InstrumentationKey=${insights.properties.InstrumentationKey}'
            }
            {
              name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
              value: '~2'
            }
            {
              name: 'XDT_MicrosoftApplicationInsights_Mode'
              value: 'default'
            }
        ]
    }
    serverFarmId: appServicePlan.id
  }  
}

// Static web app is not supporeted yet in location Norway East thats why has to be 
var anotherLocation = 'West Europe'
resource staticWebApp 'Microsoft.Web/staticSites@2021-01-01' = {
  name: staticWebAppName
  location: anotherLocation
  tags: staticWebAppTags
  properties:{}
  sku:{
    name: skuTier
  }
}
