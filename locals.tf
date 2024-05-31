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

locals {
  azurerm_subnets_name_id_map = {
    for subnet in azurerm_subnet.subnet :
    subnet.name => subnet.id
  }

  default_tags = {
    provisioner   = "terraform"
    resource_name = var.vnet_name
  }

  route_table_data_names = { for subnet_name, subnet_definition in var.subnets : subnet_definition.route_table_name => subnet_definition.route_table_name }

  subnet_route_associations = {
    for subnet_name, subnet_definition in var.subnets :
    subnet_name => subnet_definition.route_table_id != null ? subnet_definition.route_table_id : subnet_definition.route_table_name != null ? data.azurerm_route_table.existing_table[subnet_definition.route_table_name].id : null
  }

  tags = merge(local.default_tags, var.tags)
}
