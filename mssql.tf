# Create a Microsoft SQL Azure Database Server
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server
resource "azurerm_mssql_server" "main" {
  name                          = local.uuid
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = "12.0"
  administrator_login           = "mssqladmin"
  administrator_login_password  = random_password.sql_server.result
  public_network_access_enabled = false
}

# Create an admin password for the MS SQL server
resource "random_password" "sql_server" {
  length           = 128
  special          = false
  override_special = "!$#%"
  min_lower        = 2
  min_numeric      = 2
  min_upper        = 2
  number           = true
  upper            = true
  lower            = true
}

# Create a MS SQL database
resource "azurerm_mssql_database" "main" {
  name      = "main"
  server_id = azurerm_mssql_server.main.id
  tags      = {}
}
