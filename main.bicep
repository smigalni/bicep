param appServicePlanName string = 'BicepIsTheBest'
param skuName string = 'F1'
param skuTier string = 'Free'

var location = resourceGroup().location 

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-01' = {
  name: appServicePlanName
  location: location 
  sku: {
    name: skuName
    tier: skuTier
  } 
} 
