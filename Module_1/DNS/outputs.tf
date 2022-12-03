output "resource_group_id" {
  value = azurerm_resource_group.rg-001.id
}

output "dns_name_servers" {
  value = azurerm_dns_zone.public_dns-001.name_servers
}