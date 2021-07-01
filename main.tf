terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.65.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  prefix   = "vnet-sample"
  location = "West Europe"
}

resource "azurerm_resource_group" "this" {
  name     = "${local.prefix}-rg"
  location = local.location
}
