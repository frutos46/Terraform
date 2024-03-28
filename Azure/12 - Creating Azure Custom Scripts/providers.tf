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
  subscription_id = ""
  tenant_id       = ""
  client_id       = ""
  client_secret   = ""

  features {}
}