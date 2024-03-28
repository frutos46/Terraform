
## Creation of a Azure Virtual Network

resource "azurerm_resource_group" "RG01" {

  name     = "resource_group_01"
  location = "North Europe"
}

## Definition Network Security Group

resource "azurerm_network_security_group" "example_nsg_frutos46" {
  name                = "example-security-group"
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name
  depends_on = [ azurerm_resource_group.RG01 ]
}

resource "azurerm_virtual_network" "example_avn_frutos46" {
  name                = "example-network"
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.example_nsg_frutos46.id
  }

  tags = {
    environment = "DEV"
  }
  depends_on = [ azurerm_resource_group.RG01 ]
}