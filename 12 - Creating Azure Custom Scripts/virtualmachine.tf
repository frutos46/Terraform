resource "azurerm_windows_virtual_machine" "example-vm-frutos46" {
  name                = "VM01"
  resource_group_name = azurerm_resource_group.RG01.name
  location            = azurerm_resource_group.RG01.location
  size                = "Standard_D2s_V3"
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


## Definition of storate blod to upload the script

resource "azurerm_storage_account" "example-frutos46-SA" {
  name                     = "examplefruto46"
  resource_group_name      = azurerm_resource_group.RG01.name
  location                 = azurerm_resource_group.RG01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    environment = "DEV"
  }
  depends_on = [azurerm_resource_group.RG01] ## Indicate that RG should be created before this resource
}

resource "azurerm_storage_container" "example-frutos46-container" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.example-frutos46-SA.name
  container_access_type = "blob"

  depends_on = [azurerm_storage_account.example-frutos46-SA] ## Indicate that Storage account should be created before this resource
}


resource "azurerm_storage_blob" "IISConfig" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = azurerm_storage_account.example-frutos46-SA.name
  storage_container_name = azurerm_storage_container.example-frutos46-container.name
  type                   = "Block"
  source                 = "IIS_Config.ps1"

  depends_on = [azurerm_storage_container.example-frutos46-container] ## Indicate that the contair should be created before this resource

}


## Definition of extension

resource "azurerm_virtual_machine_extension" "example-extension" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_windows_virtual_machine.example-vm-frutos46.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
      {
        
        "fileUris": ["https://${azurerm_storage_account.example-frutos46-SA.name}.blob.core.windows.net/data/IIS_Config.ps1"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config.ps1"
      }
  SETTINGS


  tags = {
    environment = "DEV"
  }
}