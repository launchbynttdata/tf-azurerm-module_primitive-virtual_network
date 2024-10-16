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

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []

    content {
      enable = ddos_protection_plan.value.enable
      id     = ddos_protection_plan.value.id
    }
  }

  tags = local.tags
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  address_prefixes                              = [each.value.prefix]
  name                                          = each.key
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoints                             = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation

    content {
      name = delegation.key

      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each = {
    for subnet_name, subnet_configuration in var.subnets :
    subnet_name => subnet_configuration.network_security_group_id
    if subnet_configuration.network_security_group_id != null
  }

  network_security_group_id = each.value
  subnet_id                 = azurerm_subnet.subnet[each.key].id
}

resource "azurerm_subnet_route_table_association" "subnet_rt_association" {
  for_each = local.subnet_route_associations

  route_table_id = each.value
  subnet_id      = azurerm_subnet.subnet[each.key].id
}

data "azurerm_route_table" "existing_table" {
  for_each = local.route_table_data_names

  name                = each.key
  resource_group_name = var.resource_group_name
}
