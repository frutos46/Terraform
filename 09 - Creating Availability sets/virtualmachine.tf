resource "azurerm_windows_virtual_machine" "example-vm-frutos46" {
  name                = "VM01"
  resource_group_name = azurerm_resource_group.RG01.name
  location            = azurerm_resource_group.RG01.location
  size                = "Standard_D2s_V3"
  admin_username      = "adminuser"
  admin_password      = "Azure123"
  availability_set_id = azurerm_availability_set.example_AS_frutos46.id ## indicate that use this AS


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

  depends_on = [azurerm_network_interface.example_interface_frutos46]
}


## Adding a data disk

resource "azurerm_managed_disk" "example-adddisk-frutos46" {
  name                 = "acctestmd-frutos46"
  location             = local.location
  resource_group_name  = local.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {
    environment = "DEV"
  }

  depends_on = [azurerm_resource_group.RG01]
}


## attaching a data disk

resource "azurerm_virtual_machine_data_disk_attachment" "example-attachdisk-frutos46" {
  managed_disk_id    = azurerm_managed_disk.example-adddisk-frutos46.id
  virtual_machine_id = azurerm_windows_virtual_machine.example-vm-frutos46.id
  lun                = "0"
  caching            = "ReadWrite"

  depends_on = [azurerm_managed_disk.example-adddisk-frutos46]
}


