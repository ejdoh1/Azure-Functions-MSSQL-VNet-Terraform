# Storage Account for storing Azure Functions zip deployments
resource "azurerm_storage_account" "main" {
  name                     = local.uuid
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = {}
}

# Storage Container for storing Azure Functions zip deployments
resource "azurerm_storage_container" "main" {
  name                  = local.uuid
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}


# SAS token (read-only) to pass to Azure Functions to download zip deployment blobs
data "azurerm_storage_account_sas" "main" {
  connection_string = azurerm_storage_account.main.primary_connection_string
  https_only        = true
  start             = "2021-01-01"
  expiry            = "2031-01-01"
  resource_types {
    object    = true
    container = false
    service   = false
  }
  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
  }
}

# Upload the zip deployment package as a blob to Azure storage
resource "azurerm_storage_blob" "main" {
  name                   = "${var.zip_name}-${base64encode(filesha256("${var.zip_path}"))}.zip"
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  type                   = "Block"
  source                 = var.zip_path
}
