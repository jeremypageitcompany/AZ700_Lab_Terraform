# Private DNS zone 
resource "azurerm_private_dns_zone" "private_dns-001" {
  name                = join("", ["lab", ".", var.domain_name])
  resource_group_name = azurerm_resource_group.rg-001.name
}

# VNET Link
resource "azurerm_private_dns_zone_virtual_network_link" "private_zone_link_vnet" {
  name                  = join("", ["vnet-dns-", var.project, var.environment, var.location, "-001"])
  resource_group_name   = azurerm_resource_group.rg-001.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns-001.name
  virtual_network_id    = azurerm_virtual_network.vnet-001.id
  registration_enabled  = true
}