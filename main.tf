// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

resource "azurerm_virtual_network" "vnet" {
  address_space       = var.address_space
  location            = var.vnet_location
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  bgp_community       = var.bgp_community
  dns_servers         = var.dns_servers
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []

    content {
      enable = ddos_protection_plan.value.enable
      id     = ddos_protection_plan.value.id
    }
  }
}



resource "azurerm_subnet" "subnet_count" {
  count = var.use_for_each ? 0 : length(var.subnet_names)

  address_prefixes                              = [var.subnet_prefixes[count.index]]
  name                                          = var.subnet_names[count.index]
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  private_endpoint_network_policies_enabled     = lookup(var.subnet_private_endpoint_network_policies_enabled, var.subnet_names[count.index], false)
  private_link_service_network_policies_enabled = lookup(var.subnet_private_link_service_network_policies_enabled, var.subnet_names[count.index], false)
  service_endpoints                             = lookup(var.subnet_service_endpoints, var.subnet_names[count.index], null)

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, var.subnet_names[count.index], {})

    content {
      name = delegation.key

      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }
}

resource "azurerm_subnet" "subnet_for_each" {
  for_each = var.use_for_each ? toset(var.subnet_names) : []

  address_prefixes                              = [local.subnet_names_prefixes[each.value]]
  name                                          = each.value
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  private_endpoint_network_policies_enabled     = lookup(var.subnet_private_endpoint_network_policies_enabled, each.value, false)
  private_link_service_network_policies_enabled = lookup(var.subnet_private_link_service_network_policies_enabled, each.value, false)
  service_endpoints                             = lookup(var.subnet_service_endpoints, each.value, null)

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, each.value, {})

    content {
      name = delegation.key

      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }
}


resource "azurerm_subnet_network_security_group_association" "vnet" {
  for_each = var.nsg_ids

  network_security_group_id = each.value
  subnet_id                 = local.azurerm_subnets_name_id_map[each.key]
}

resource "azurerm_subnet_route_table_association" "vnet" {
  for_each = var.route_tables_ids

  route_table_id = each.value
  subnet_id      = local.azurerm_subnets_name_id_map[each.key]
}