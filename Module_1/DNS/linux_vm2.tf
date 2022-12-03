# pip
resource "azurerm_public_ip" "pip-002" {
  name                = join("", ["pip-", var.project, var.environment, var.location, "-002"])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-001.name
  allocation_method   = "Static"
  tags                = var.resource_tags
  sku                 = "Standard"
}


# NIC
resource "azurerm_network_interface" "nic_001-vm002" {
  name                = join("", ["nic-vm002", var.project, var.environment, var.location, "-001"])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-001.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_002-vnet001.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-002.id
  }
}

resource "azurerm_linux_virtual_machine" "vm002" {
  name                            = join("", ["vm", var.project, var.environment, var.location, "-002"])
  resource_group_name             = azurerm_resource_group.rg-001.name
  location                        = var.location
  size                            = "Standard_F2"
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic_001-vm002.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}