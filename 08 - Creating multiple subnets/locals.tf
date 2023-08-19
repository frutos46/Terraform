###################################################################################
## Definition local variables and outputs values
###################################################################################



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



