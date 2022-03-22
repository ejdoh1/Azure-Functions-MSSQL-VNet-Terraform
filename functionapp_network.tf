# Associate the Function App with the Virtual Network subnet
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection#example-usage-with-function-app
resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  app_service_id = azurerm_function_app.main.id
  subnet_id      = azurerm_subnet.functions.id
}
