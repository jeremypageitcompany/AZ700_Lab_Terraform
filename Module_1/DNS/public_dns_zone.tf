
# Public DNS Zone
resource "azurerm_dns_zone" "public_dns-001" {
  name                = var.domain_name
  resource_group_name = azurerm_resource_group.rg-001.name

}

# A record Public DNS zones
resource "azurerm_dns_a_record" "a_record-001" {
  name                = azurerm_linux_virtual_machine.vm001.name
  zone_name           = azurerm_dns_zone.public_dns-001.name
  resource_group_name = azurerm_resource_group.rg-001.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip-001.id

}

resource "azurerm_dns_a_record" "a_record-002" {
  name                = azurerm_linux_virtual_machine.vm002.name
  zone_name           = azurerm_dns_zone.public_dns-001.name
  resource_group_name = azurerm_resource_group.rg-001.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip-002.id

}