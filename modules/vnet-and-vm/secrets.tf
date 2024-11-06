resource "azurerm_key_vault" "this" {
  name                       = "${local.name}-keyvault"
  location                   = module.networking.resource_group_location
  resource_group_name        = module.networking.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]
  }

  tags = module.ctags.common_tags
}

resource "random_string" "username" {
  length  = 4
  special = false
}

resource "random_password" "password" {
  length           = 24
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "username_secret" {
  name         = "${local.name}-vm-username"
  value        = "admin_${random_string.username.result}"
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "password_secret" {
  name         = "${local.name}-vm-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.this.id
}
