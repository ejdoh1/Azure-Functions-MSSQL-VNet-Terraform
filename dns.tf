# Create a DNS Zone to store the SQL Sever A record
resource "azurerm_private_dns_zone" "main" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

# Link the Private DNS Zone with the Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "networklink-${azurerm_private_dns_zone.main.name}"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
}

# Create the DNS A record for the SQL server (private IP address)
resource "azurerm_private_dns_a_record" "main" {
  name                = azurerm_mssql_server.main.name
  zone_name           = azurerm_private_dns_zone.main.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 3600
  records             = [azurerm_private_endpoint.mssql.private_service_connection[0].private_ip_address]
}
