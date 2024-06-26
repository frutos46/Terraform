## Definition data block to declare tenant configuration

data "azurerm_client_config" "current"{}



## Definition of Azure Key Vault

resource "azurerm_key_vault" "example-AKV-frutos46" {
  name                        = "examplekeyvault-frutos46"
  location                    = local.location
  resource_group_name         = local.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id


    secret_permissions = [
      "Get", "Set"
    ]


  }
}


## Definition of a secrret

resource "azurerm_key_vault_secret" "secret" {
  name         = "vmpassword"
  value        = "Azure@123"
  key_vault_id = azurerm_key_vault.example-AKV-frutos46.id

  depends_on = [
    azurerm_key_vault.example-AKV-frutos46
  ]
}