

#####################################################################################
## Deploy infraestracture
#####################################################################################

## Creation of a Resource Group

resource "azurerm_resource_group" "RG01" {

  name     = local.resource_group_name
  location = local.location
}



## Definition of Virtual Network

resource "azurerm_virtual_network" "example_avn_frutos46" {
  name                = local.virtual_network.name
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name
  address_space       = [local.virtual_network.address_space]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "DEV"
  }
  depends_on = [azurerm_resource_group.RG01]
}

## Definition of subnets

resource "azurerm_subnet" "example-subnets" {
  count                = var.number_of_subnets
  name                 = "Subnet${count.index}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.${count.index}.0/24"]

  depends_on = [azurerm_virtual_network.example_avn_frutos46]
}

resource "azurerm_network_security_group" "example_nsg_frutos46" {
  name                = "example-securitygroup-frutos46"
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name

  ## Allow RDP traffic
  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "DEV"
  }

  depends_on = [azurerm_resource_group.RG01]
}

resource "azurerm_subnet_network_security_group_association" "example-nsg-to-subnet-frutos46" {
  count                     = var.number_of_subnets
  subnet_id                 = azurerm_subnet.example-subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.example_nsg_frutos46.id

  depends_on = [
    azurerm_virtual_network.example_avn_frutos46,
    azurerm_network_security_group.example_nsg_frutos46
  ]

}
