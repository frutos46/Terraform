## Definition Azure bastion host

resource "azurerm_bastion_host" "example-azure-bastion" {
  name                = var.name-bastion
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.example-bastion-subnetd.id
    public_ip_address_id = azurerm_public_ip.example-bastion-publicip.id
  }
}