module "networking" {
  source = "git@github.com:hmcts/terraform-module-azure-virtual-networking?ref=main"

  env         = "sbox"
  product     = var.product
  common_tags = module.ctags.common_tags
  component   = var.component

  vnets = {
    vnet = {
      address_space = [var.vnet_address_space]
      subnets = {
        snet = {
          address_prefixes = [var.vnet_address_space]
        }
      }
    }
  }

  route_tables = {
    rt = {
      subnets = ["vnet-snet"]
      routes = {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.10.200.36"
        }
        pin-test = {
          address_prefix         = "10.10.220.0/22"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.10.200.36"
        }
      }
    }
  }

  network_security_groups = {
    nsg = {
      subnets = ["vnet-snet"]
      rules = {
        "allow_ssh" = {
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = var.allowed_source_address_prefix
          destination_address_prefix = var.vnet_address_space
        }
        "allow_ssh_bastion" = {
          priority                   = 210
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefixes    = ["10.10.200.37", "10.10.200.38"]
          destination_address_prefix = var.vnet_address_space
        }
      }
    }
  }
}

module "vnet_peer_hub" {
  source = "github.com/hmcts/terraform-module-vnet-peering?ref=feat%2Ftweak-to-enable-planning-in-a-clean-env"
  peerings = {
    source = {
      name           = "${local.name}-vnet-to-hub"
      vnet_id        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${module.networking.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${module.networking.vnet_names["vnet"]}"
      vnet           = module.networking.vnet_names["vnet"]
      resource_group = module.networking.resource_group_name
    }
    target = {
      name           = "hub-to-${local.name}-vnet"
      vnet           = var.hub_vnet_name
      resource_group = var.hub_resource_group_name
    }
  }

  providers = {
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub
  }
}
