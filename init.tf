terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "azurerm" {
  subscription_id = "a8140a9e-f1b0-481f-a4de-09e2ee23f7ab"
  features {}
}
provider "azurerm" {
  alias           = "hub"
  subscription_id = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
  features {}
}

provider "random" {}
