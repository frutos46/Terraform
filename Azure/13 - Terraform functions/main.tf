## Definition local variables

locals {
  common_tags = {
    environment = "DEV"
    tier        = 3
    deparment   = "IT"
  }
}
## Creation of a RG

resource "azurerm_resource_group" "RG01" {

  name     = "resource_group_01"
  location = "North Europe"
}

# Use terraform resources

resource "random_uuid" "identifier-random" {} # generate a random id

output "randomid" {
  value = random_uuid.identifier-random.result
}

output "randomid-substring" {
  value = substr(random_uuid.identifier-random.result, 0, 8) ## split the first 8 characters with substring
}


## Example with FOR expresion

resource "azurerm_storage_account" "example_frutos46" {
  name                     = "examplefruto46"
  resource_group_name      = azurerm_resource_group.RG01.name
  location                 = azurerm_resource_group.RG01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    for name, value in local.common_tags : name => "${value}"
  }
  depends_on = [azurerm_resource_group.RG01] ## Indicate that RG should be created before this resource
}


