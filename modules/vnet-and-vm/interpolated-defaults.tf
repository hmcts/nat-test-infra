data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

module "ctags" {
  source = "github.com/hmcts/terraform-module-common-tags"

  builtFrom   = var.builtFrom
  environment = var.env
  product     = var.product
}

locals {
  name = "${var.product}-${var.component}"
}
