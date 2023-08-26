###################################################################################
## Definition local variables and outputs values
###################################################################################

## local variables
locals {
  resource_group_name = "resource_group_01"
  location            = "North Europe"
  virtual_network = {
    name          = "example-network"
    address_space = "10.0.0.0/16"
  }

  subnet = [
    {
      name           = "subnetA"
      address_prefix = "10.0.1.0/24"

    },

    {
      name           = "subnetB"
      address_prefix = "10.0.2.0/24"
    }

  ]

}

## outputs values

output "subnetA-id" {
  value = azurerm_subnet.example-subnetA.id
}



#####################################################################################
## Deploy infraestracture
#####################################################################################

## Creation of a Resource Group

resource "azurerm_resource_group" "RG01" {

  name     = local.resource_group_name
  location = local.location
}

## Definition of Network Security Group

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
  subnet_id                 = azurerm_subnet.example-subnetA.id
  network_security_group_id = azurerm_network_security_group.example_nsg_frutos46.id

  depends_on = [azurerm_network_security_group.example_nsg_frutos46]

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

resource "azurerm_subnet" "example-subnetA" {
  name                 = local.subnet[0].name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnet[0].address_prefix]

  depends_on = [azurerm_virtual_network.example_avn_frutos46]
}
## Definition of bastion subnet
resource "azurerm_subnet" "example-bastion-subnetd" {
  name                 = var.bastion-subnet
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.10.0/24"]

  depends_on = [azurerm_virtual_network.example_avn_frutos46]
}

resource "azurerm_subnet" "example_subnetB" {
  name                 = local.subnet[1].name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnet[1].address_prefix]

  depends_on = [azurerm_virtual_network.example_avn_frutos46]

}


## Creation of a new interface

resource "azurerm_network_interface" "example_interface_frutos46" {
  name                = "example-nic_frutos46"
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name

  ip_configuration {
    name = "internal"
    ## both option are valid, but the second one is a list, and it's necessary use the parameter tolist
    ## to convert the data in a list
    subnet_id = azurerm_subnet.example-subnetA.id
    #subnet_id                     = tolist(azurerm_virtual_network.example_avn_frutos46.subnet)[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example-publicip-frutos46.id
  }

  depends_on = [azurerm_subnet.example-subnetA]
  # depends_on = [azurerm_virtual_network.example_avn_frutos46]
}


## Definition of a public ipc

resource "azurerm_public_ip" "example-publicip-frutos46" {
  name                = "acceptanceTestPublicIp1-frutos46"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"

  tags = {
    environment = "DEV"
  }
  depends_on = [azurerm_resource_group.RG01]
}

resource "azurerm_public_ip" "example-bastion-publicip" {
  name                = var.bastion-publicip
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "DEV"
  }
  depends_on = [azurerm_resource_group.RG01]
}