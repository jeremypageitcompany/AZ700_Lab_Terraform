# Terraform tf file for vnet_2

resource "azurerm_virtual_network" "vnet-002" {
  resource_group_name = azurerm_resource_group.rg-001.name
  name                = join("", ["vnet-", var.project, var.environment, var.location, "-002"])
  location            = var.resource_group_location_2
  address_space       = var.subnet_vnet-002
  tags                = var.resource_tags
}

resource "azurerm_subnet" "subnet_001-vnet002" {
  name                 = join("", ["subnet-vnet002-", var.project, var.environment, var.location, "-001"])
  resource_group_name  = azurerm_resource_group.rg-001.name
  virtual_network_name = azurerm_virtual_network.vnet-002.name
  address_prefixes     = var.subnet001-vnet002
}

resource "azurerm_public_ip" "pip-002" {
  name                = join("", ["pip-", var.project, var.environment, var.location, "-002"])
  location            = var.resource_group_location_2
  resource_group_name = azurerm_resource_group.rg-001.name
  allocation_method   = "Dynamic"
  tags                = var.resource_tags
}


resource "azurerm_network_interface" "nic_001-vm002" {
  name                = join("", ["nic-vm002", var.project, var.environment, var.location, "-001"])
  location            = var.resource_group_location_2
  resource_group_name = azurerm_resource_group.rg-001.name
  tags                = var.resource_tags

  ip_configuration {

    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_001-vnet002.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-002.id
  }
}

resource "azurerm_linux_virtual_machine" "vm002" {
  name                            = join("", ["vm", var.project, var.environment, var.location, "-002"])
  resource_group_name             = azurerm_resource_group.rg-001.name
  location                        = var.resource_group_location_2
  size                            = "Standard_F2"
  admin_username                  = var.vm_username
  disable_password_authentication = false
  admin_password                  = var.vm_password


  network_interface_ids = [
    azurerm_network_interface.nic_001-vm002.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "myOSdisk2"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "nsg-002" {
  name                = join("", ["nsg-", var.project, var.environment, var.location, "-002"])
  location            = var.resource_group_location_2
  resource_group_name = azurerm_resource_group.rg-001.name
  tags                = var.resource_tags

  security_rule = [{
    access                                     = "Allow"
    description                                = "AllowInboundSSHHome"
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

resource "azurerm_network_interface_security_group_association" "association-002" {
  network_interface_id      = azurerm_network_interface.nic_001-vm002.id
  network_security_group_id = azurerm_network_security_group.nsg-002.id
}