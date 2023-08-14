# 
## Creation of a RG

resource "azurerm_resource_group" "RG01" {

  name     = "resource_group_01"
  location = "North Europe"
}