resource_group_name = "dso-k8s-001"
use_for_each        = true
vnet_location       = "eastus"
address_space       = ["10.0.0.0/16"]
subnet_names        = ["system-pool-subnet", "user-pool-subnet-1", "user-pool-subnet-2", "acr-subnet", "bastion-subnet"]
subnet_prefixes     = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24", "10.0.54.0/24", "10.0.55.0/24"]
subnet_private_endpoint_network_policies_enabled = {
  system-pool-subnet = true
  user-pool-subnet-1 = false
  user-pool-subnet-2 = false
  acr-subnet         = false
  bastion-subnet     = false

}
vnet_name = "govt-k8s-vnet-001"
tags = {
  environment = "sandbox"
  owner       = "Launch-DSO"
  Purpose     = "K8s Cluster test in Govt CLoud"
}
