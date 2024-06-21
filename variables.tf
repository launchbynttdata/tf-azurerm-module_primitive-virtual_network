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

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to be imported."
  nullable    = false
}

variable "vnet_location" {
  type        = string
  description = "The location of the vnet to create."
  nullable    = false
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}

variable "bgp_community" {
  type        = string
  default     = null
  description = "(Optional) The BGP community attribute in format `<as-number>:<community-value>`."
}

variable "ddos_protection_plan" {
  type = object({
    enable = bool
    id     = string
  })
  default     = null
  description = "The set of DDoS protection plan configuration"
}

# If no values specified, this defaults to Azure DNS
variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "The DNS servers to be used with vNet."
}

variable "subnets" {
  description = "A mapping of subnet names to their configurations."
  type = map(object({
    prefix = string
    delegation = optional(object({
      name    = string
      actions = list(string)
    }), null)
    service_endpoints                             = optional(list(string), []),
    private_endpoint_network_policies_enabled     = optional(bool, false)
    private_link_service_network_policies_enabled = optional(bool, false)
    network_security_group_id                     = optional(string, null)
    route_table_id                                = optional(string, null)
    route_table_name                              = optional(string, null)
  }))
  default = {}

  validation {
    condition     = alltrue([for subnet_name, subnet in var.subnets : subnet.route_table_id == null || subnet.route_table_name == null ? true : subnet.route_table_id == null && subnet.route_table_name == null ? true : false])
    error_message = "Subnets may define either a route_table_id or a route_table_name, but not both."
  }
}

variable "vnet_name" {
  type        = string
  description = "Name of the vnet to create"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The tags to associate with resources provisioned by this module."
}
