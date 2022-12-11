# Terraform tf file for vnet_1

resource "azurerm_virtual_network" "vnet-001" {
  resource_group_name = azurerm_resource_group.rg-001.name
  name                = join("", ["vnet-", var.project, var.environment, var.location, "-001"])
  location            = var.location
  address_space       = var.subnet_vnet-001
  tags                = var.resource_tags
}

resource "azurerm_subnet" "subnet_001-vnet001" {
  name                 = join("", ["subnet-vnet001-", var.project, var.environment, var.location, "-001"])
  resource_group_name  = azurerm_resource_group.rg-001.name
  virtual_network_name = azurerm_virtual_network.vnet-001.name
  address_prefixes     = var.subnet001-vnet001
}


resource "azurerm_public_ip" "pip-001" {
  name                = join("", ["pip-", var.project, var.environment, var.location, "-001"])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-001.name
  allocation_method   = "Dynamic"
  tags                = var.resource_tags
}


resource "azurerm_network_interface" "nic_001-vm001" {
  name                = join("", ["nic-vm001", var.project, var.environment, var.location, "-001"])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-001.name
  tags                = var.resource_tags

  ip_configuration {

    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_001-vnet001.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-001.id
  }
}

resource "azurerm_linux_virtual_machine" "vm001" {
  name                = join("", ["vm", var.project, var.environment, var.location, "-001"])
  resource_group_name = azurerm_resource_group.rg-001.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.vm_username
  tags                = var.resource_tags

  # If not using ssh key, require to set password auth to false
  disable_password_authentication = false
  admin_password                  = var.vm_password


  network_interface_ids = [
    azurerm_network_interface.nic_001-vm001.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "myOSdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "nsg-001" {
  name                = join("", ["nsg-", var.project, var.environment, var.location, "-001"])
  location            = var.location
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

resource "azurerm_network_interface_security_group_association" "association-001" {
  network_interface_id      = azurerm_network_interface.nic_001-vm001.id
  network_security_group_id = azurerm_network_security_group.nsg-001.id

}