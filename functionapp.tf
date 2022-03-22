
# Azure Functions needs an App Service Plan
resource "azurerm_app_service_plan" "main" {
  name                = "functionsapp-svc-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  kind                = "FunctionApp"
  tags                = {}
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Creates the Azure Function App functions
resource "azurerm_function_app" "main" {
  name                       = local.uuid
  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.main.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  version                    = "~2"
  tags                       = {}
  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "dotnet"
    FUNCTION_APP_EDIT_MODE         = "readonly"
    HASH                           = "${base64encode(filesha256("${var.zip_path}"))}"
    WEBSITE_RUN_FROM_PACKAGE       = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/${azurerm_storage_container.main.name}/${azurerm_storage_blob.main.name}${data.azurerm_storage_account_sas.main.sas}"
    WEBSITE_VNET_ROUTE_ALL         = "1"
    WEBSITE_CONTENTOVERVNET        = "1"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.main.instrumentation_key
    ConnectionString               = "Server=${azurerm_mssql_server.main.name}.${azurerm_private_dns_zone.main.name};Database=${azurerm_mssql_database.main.name};User Id=${azurerm_mssql_server.main.administrator_login};Password=${azurerm_mssql_server.main.administrator_login_password};"
  }
  site_config {
    always_on = true
  }
}

resource "azurerm_application_insights" "main" {
  name                = local.uuid
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  application_type    = "web"
}
