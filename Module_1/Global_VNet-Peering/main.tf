
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-001" {
  name     = join("", ["rg-", var.project, var.environment, var.location, "-001"])
  location = var.location
  tags     = var.resource_tags
}

resource "azurerm_virtual_network_peering" "peering-001" {
  name                      = join("", ["peering-", var.project, var.environment, var.location, "-001"])
  resource_group_name       = azurerm_resource_group.rg-001.name
  virtual_network_name      = azurerm_virtual_network.vnet-001.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-002.id
}

resource "azurerm_virtual_network_peering" "peering-002" {
  name                      = join("", ["peering-", var.project, var.environment, var.location, "-002"])
  resource_group_name       = azurerm_resource_group.rg-001.name
  virtual_network_name      = azurerm_virtual_network.vnet-002.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-001.id
}