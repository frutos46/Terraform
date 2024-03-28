## Definition Azure provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.68.0"
    }
  }
}

## Authorization to connect with Azure Portal

provider "azurerm" {
  subscription_id = "XXXXXX-XXXX-XXXXX-XXX-XXXXX"
  tenant_id       = "XXXXXX-XXXX-XXXXX-XXX-XXXXX"
  client_id       = "XXXXXX-XXXX-XXXXX-XXX-XXXXX"
  client_secret   = "XXXXXX-XXXX-XXXXX-XXX-XXXXX"

  features {}
}