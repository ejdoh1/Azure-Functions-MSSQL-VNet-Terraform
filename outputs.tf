output "api_url" {
  value = "https://${azurerm_function_app.main.default_hostname}/api/HttpExample"
}
output "functionapp_package_url" {
  value     = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/${azurerm_storage_container.main.name}/${azurerm_storage_blob.main.name}${data.azurerm_storage_account_sas.main.sas}"
  sensitive = true
}
output "connection_string" {
  value     = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.main.name};User Id=${azurerm_mssql_server.main.administrator_login};Password=${azurerm_mssql_server.main.administrator_login_password};"
  sensitive = true
}
output "mssql_servername" {
  value = azurerm_mssql_server.main.name
}
output "mssql_username" {
  value = azurerm_mssql_server.main.administrator_login
}
output "mssql_password" {
  value     = azurerm_mssql_server.main.administrator_login_password
  sensitive = true
}
output "mssql_fqdn" {
  value     = azurerm_mssql_server.main.fully_qualified_domain_name
  sensitive = true
}
output "mssql_fqdn_private" {
  value     = "Server=${azurerm_mssql_server.main.name}.${azurerm_private_dns_zone.main.name};Database=${azurerm_mssql_database.main.name};User Id=${azurerm_mssql_server.main.administrator_login};Password=${azurerm_mssql_server.main.administrator_login_password};"
  sensitive = true
}
