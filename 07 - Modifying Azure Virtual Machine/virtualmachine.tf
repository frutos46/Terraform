resource "azurerm_windows_virtual_machine" "example-vm-frutos46" {
  name                = "VM01"
  resource_group_name = azurerm_resource_group.RG01.name
  location            = azurerm_resource_group.RG01.location
  size                = "Standard_D2S_V3"
  admin_username      = "adminuser"
  admin_password      = "Azure123"

  network_interface_ids = [
    azurerm_network_interface.example_interface_frutos46.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [ azurerm_network_interface.example_interface_frutos46 ]
}