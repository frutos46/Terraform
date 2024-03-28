
## Creation of a Azure Storage Account 

resource "azurerm_resource_group" "RG01" {

  name     = "resource_group_01"
  location = "North Europe"
}


resource "azurerm_storage_account" "example_frutos46" {
  name                     = "examplefruto46"
  resource_group_name      = azurerm_resource_group.RG01.name
  location                 = azurerm_resource_group.RG01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    environment = "DEV"
  }
  depends_on = [azurerm_resource_group.RG01] ## Indicate that RG should be created before this resource
}

## Uploading a blob


resource "azurerm_storage_container" "example_frutos46" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.example_frutos46.name
  container_access_type = "blob"

  depends_on = [azurerm_storage_account.example_frutos46] ## Indicate that Storage account should be created before this resource
}


resource "azurerm_storage_blob" "example_frutos46" {
  name                   = "main.tf"
  storage_account_name   = azurerm_storage_account.example_frutos46.name
  storage_container_name = azurerm_storage_container.example_frutos46.name
  type                   = "Block"
  source                 = "main.tf"

  depends_on = [azurerm_storage_container.example_frutos46] ## Indicate that the contair should be created before this resource

}