@description('Name of the Virtual Network')
param vnetName string = 'threeTierVnet'

@description('Address prefix for the Virtual Network')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Address prefix for the Web subnet')
param webSubnetPrefix string = '10.0.1.0/24'

@description('Address prefix for the App subnet')
param appSubnetPrefix string = '10.0.2.0/24'

@description('Address prefix for the DB subnet')
param dbSubnetPrefix string = '10.0.3.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'web'
        properties: {
          addressPrefix: webSubnetPrefix
          networkSecurityGroup: {
            id: webNsg.id
          }
        }
      }
      {
        name: 'app'
        properties: {
          addressPrefix: appSubnetPrefix
          networkSecurityGroup: {
            id: appNsg.id
          }
        }
      }
      {
        name: 'db'
        properties: {
          addressPrefix: dbSubnetPrefix
          networkSecurityGroup: {
            id: dbNsg.id
          }
        }
      }
    ]
  }
}

resource webNsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: 'web-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'AllowHTTP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'AllowHTTPS'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource appNsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: 'app-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'AllowWebToApp'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '8080'
          sourceAddressPrefix: webSubnetPrefix
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource dbNsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: 'db-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'AllowAppToDb'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: appSubnetPrefix
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
