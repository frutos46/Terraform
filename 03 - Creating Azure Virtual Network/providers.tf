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
  subscription_id = "c0ddc6c0-dfb3-4fc7-a793-7dc6e0968d20"
  tenant_id       = "8b928c33-a1cf-4871-bc4c-5b7ede54fcab"
  client_id       = "88ac6240-131f-4af4-bb57-e6862d826055"
  client_secret   = "R1w8Q~987xoF6URXuViBWU9oGKh.xy1wZpDlwdqq"

  features {}
}