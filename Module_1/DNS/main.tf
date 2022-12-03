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


# Resource Group
resource "azurerm_resource_group" "rg-001" {
  name     = join("", ["rg-", var.project, var.environment, var.location, "-001"])
  location = var.location
  tags     = var.resource_tags
}


# VNET
resource "azurerm_virtual_network" "vnet-001" {
  name                = join("", ["vnet-", var.project, var.environment, var.location, "-001"])
  resource_group_name = azurerm_resource_group.rg-001.name
  location            = var.location
  address_space       = [var.subnet_vnet-001]
  tags                = var.resource_tags
}


# Subnet
resource "azurerm_subnet" "subnet_001-vnet001" {
  name                 = join("", ["subnet-vnet001-", var.project, var.environment, var.location, "-001"])
  resource_group_name  = azurerm_resource_group.rg-001.name
  virtual_network_name = azurerm_virtual_network.vnet-001.name
  address_prefixes     = [var.subnet001-vnet001]
}

resource "azurerm_subnet" "subnet_002-vnet001" {
  name                 = join("", ["subnet-vnet001-", var.project, var.environment, var.location, "-002"])
  resource_group_name  = azurerm_resource_group.rg-001.name
  virtual_network_name = azurerm_virtual_network.vnet-001.name
  address_prefixes     = [var.subnet002-vnet001]
}

resource "azurerm_subnet" "subnet_003-vnet001" {
  name                 = join("", ["subnet-vnet001-", var.project, var.environment, var.location, "-003"])
  resource_group_name  = azurerm_resource_group.rg-001.name
  virtual_network_name = azurerm_virtual_network.vnet-001.name
  address_prefixes     = [var.subnet003-vnet001]
}

resource "azurerm_network_security_group" "nsg-001" {
  name                = join("", ["nsg-", var.project, var.environment, var.location, "-001"])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-001.name
  tags                = var.resource_tags

  security_rule = [{
    access                                     = "Allow"
    description                                = "AllowInboundHome"
    destination_address_prefix                 = "*"
    destination_port_range                     = ""
    direction                                  = "Inbound"
    name                                       = "AllowInboundSSHhome"
    priority                                   = 100 # between 100 - 4096
    protocol                                   = "Tcp"
    source_address_prefix                      = "${chomp(data.http.myip.body)}" # nsg dont do FQDN, maybe a way to resolve it w powershell and send trhough variable
    source_port_range                          = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_ranges                    = ["22"]
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_ranges                         = []
  }]
}

resource "azurerm_subnet_network_security_group_association" "association-001" {
  subnet_id                 = azurerm_subnet.subnet_001-vnet001.id
  network_security_group_id = azurerm_network_security_group.nsg-001.id
}