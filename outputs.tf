output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = azurerm_virtual_network.vnet.address_space
}

output "vnet_guid" {
  description = "The GUID of the newly created vNet"
  value       = azurerm_virtual_network.vnet.guid
}

output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = azurerm_virtual_network.vnet.location
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_name_id_map" {
  description = "Maps the names of the subnets to the ID created."
  value       = local.azurerm_subnets_name_id_map
}

output "subnet_map" {
  description = "Maps the name of the subnets to their full outputs."
  value       = azurerm_subnet.subnet
}

output "subnet_route_associations" {
  value = local.subnet_route_associations
}
