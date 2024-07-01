address_space = ["172.16.0.0/24"]
subnets = {
  subnet_a = {
    prefix = "172.16.0.0/26"
  },
  subnet_b = {
    prefix = "172.16.0.64/26"
  }
  subnet_c = {
    prefix = "172.16.0.128/26"
  }
  subnet_d = {
    prefix = "172.16.0.192/26"
    delegation = {
      dns-resolver = {
        service_name    = "Microsoft.Network/dnsResolvers"
        service_actions = ["Microsoft.Network/virtualNetworks/read"]
      }
    }
  }
}
