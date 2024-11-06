terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "3.116.0"
      configuration_aliases = [azurerm.hub]
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}
