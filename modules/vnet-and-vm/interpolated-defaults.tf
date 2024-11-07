data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

module "ctags" {
  source = "github.com/hmcts/terraform-module-common-tags"

  builtFrom    = var.builtFrom
  environment  = var.env
  product      = var.product
  expiresAfter = "2025-01-01"
}

locals {
  name = "${var.product}-${var.component}"
}
