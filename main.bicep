param appServicePlanName string = 'BicepIsTheBest'
param appServiceName string = 'BicepIsTheBest'
param skuName string = 'F1'
param skuTier string = 'Free'
param staticWebAppName string = 'BicepIsTheBest'
param appServiceTags object
param insightsTags object
param staticWebAppTags object

param location string = resourceGroup().location 

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

resource staticWebApp 'Microsoft.Web/staticSites@2021-03-01' = {
  name: staticWebAppName
  location: location
  tags: staticWebAppTags
  properties:{}
  sku:{
    name: skuTier
  }
}
