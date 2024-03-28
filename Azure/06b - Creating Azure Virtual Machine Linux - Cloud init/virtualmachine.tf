
## Deploy configuration with CloudInit in CustomTemplate

data "template_file" "CloudInitData" {
  template = file("script.sh")
}


## Deploy linux machine

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.RG01.name
  location            = azurerm_resource_group.RG01.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Agosto@2023"
  disable_password_authentication = false
  custom_data         = base64encode(data.template_file.CloudInitData.rendered) # take the content of the file .sh
  network_interface_ids = [
    azurerm_network_interface.example_interface_frutos46.id
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}