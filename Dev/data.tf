###############################################################

data "azurerm_key_vault" "db" {
  name                = "keysecret007"
  resource_group_name = "todo-keyvault"
}

data "azurerm_key_vault_secret" "db_username" {
  name         = "todo-db-username"
  key_vault_id = data.azurerm_key_vault.db.id
}

data "azurerm_key_vault_secret" "db_password" {
  name         = "todo-db-password"
  key_vault_id = data.azurerm_key_vault.db.id
}
###############################################################

data "azurerm_key_vault" "frontend" {
  name                = "keysecret007"
  resource_group_name = "todo-keyvault"
}

data "azurerm_key_vault_secret" "frontend_username" {
  name         = "frontend-vm-username"
  key_vault_id = data.azurerm_key_vault.frontend.id
}

data "azurerm_key_vault_secret" "frontend_password" {
  name         = "frontend-vm-pass"
  key_vault_id = data.azurerm_key_vault.frontend.id
}
###############################################################

data "azurerm_key_vault" "backend" {
  name                = "keysecret007"
  resource_group_name = "todo-keyvault"
}

data "azurerm_key_vault_secret" "bakend_username" {
  name         = "Backend-vm-username"
  key_vault_id = data.azurerm_key_vault.backend.id
}

data "azurerm_key_vault_secret" "backend_password" {
  name         = "Backend-vm-pass"
  key_vault_id = data.azurerm_key_vault.backend.id
}
###############################################################