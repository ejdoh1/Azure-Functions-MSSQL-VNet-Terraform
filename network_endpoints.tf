# Connect the MS SQL Server with the Virtual Network endpoints subnet
# Private Endpoint uses a private IP address from your VNet, effectively bringing the service into your VNet. 
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
resource "azurerm_private_endpoint" "mssql" {
  name                = "mssql-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.endpoints.id
  private_service_connection {
    name                           = "mssql-private-service-connection"
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
}
