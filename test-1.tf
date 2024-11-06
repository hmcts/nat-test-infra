module "test-1" {
  source = "./modules/vnet-and-vm"

  component                     = "nat-test-1"
  vnet_address_space            = "10.10.221.0/24"
  allowed_source_address_prefix = "10.10.220.0/24"

  providers = {
    azurerm     = azurerm
    azurerm.hub = azurerm.hub
  }
}
