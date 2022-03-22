# Virtual network subnet for service endpoints
resource "azurerm_subnet" "endpoints" {
  name                                           = "endpoints"
  resource_group_name                            = azurerm_resource_group.main.name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = ["10.0.2.0/24"]
  enforce_private_link_service_network_policies  = true
  enforce_private_link_endpoint_network_policies = true
  # Associate MS SQL Service Endpoints with the subnet
  service_endpoints = ["Microsoft.Sql"]
}

# Virtual network subnet for Azure Functions
resource "azurerm_subnet" "functions" {
  name                                           = "functions"
  resource_group_name                            = azurerm_resource_group.main.name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = ["10.0.1.0/24"]
  enforce_private_link_service_network_policies  = true
  enforce_private_link_endpoint_network_policies = true
  delegation {
    name = "serverFarmsDelegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
