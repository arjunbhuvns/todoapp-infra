module "resource_groups" {
  source   = "../module/1azurerm_resource_group"
    name     = "dev-todo-rg"
    loc      = "southafricanorth"
}
################################################################################################
module "Vnet" {
  depends_on = [ module.resource_groups ]
    source = "../module/2azurerm_virtual_network"

      name           = "todo-vnet"
      ad_space       = ["10.0.0.0/16"]
      vnet_location  = "southafricanorth"
      rg_name        = "dev-todo-rg"
}

################################################################################################
module "frontend-subnet" {
  depends_on = [ module.Vnet ]
    source = "../module/3azurerm_subnet"

      name            = "todo-frontend-subnet"
      rg_name         = "dev-todo-rg"
      vnet_name       = "todo-vnet"
      address_prefixes = ["10.0.0.0/27"]
  
}

module "backend-subnet" {
  depends_on = [ module.Vnet ]
    source = "../module/3azurerm_subnet"

      name            = "todo-backend-subnet"
      rg_name         = "dev-todo-rg"
      vnet_name       = "todo-vnet"
      address_prefixes = ["10.0.0.32/27"]
}
################################################################################################
module "frontend-nsg" {
  depends_on = [ module.Vnet]
    source = "../module/4azurerm_nsg"

      name            = "todo-frontend-nsg"
      location        = "southafricanorth"
      rg_name         = "dev-todo-rg"
}

module "backend-nsg" {
  depends_on = [ module.Vnet]
    source = "../module/4azurerm_nsg"

      name            = "todo-backend-nsg"
      location        = "southafricanorth"
      rg_name         = "dev-todo-rg"
}

################################################################################################
module "frontend-nsg-association" {
  depends_on = [ module.frontend-nsg, module.frontend-subnet, module.Vnet ]
    source = "../module/4azurerm_nsg_asso"
          subnet_id       = module.frontend-subnet.subnet_id
          nsg_id          = module.frontend-nsg.nsg_id
  
}

module "backend-nsg-association" {
  depends_on = [ module.backend-nsg, module.backend-subnet, module.Vnet ]
    source = "../module/4azurerm_nsg_asso"
        subnet_id       = module.backend-subnet.subnet_id
        nsg_id          = module.backend-nsg.nsg_id
  
}

################################################################################################
module "frontend-vm" {
  depends_on = [ module.frontend-subnet ]
    source = "../module/4azurerm_virtual_machine"
    
      name            = "todo-frontend-vm"
      location        = "southafricanorth"
      rg_name         = "dev-todo-rg"
      subnet_id       = module.frontend-subnet.subnet_id
      admin_username  = data.azurerm_key_vault_secret.frontend_username.value
      admin_password  = data.azurerm_key_vault_secret.frontend_password.value
}


module "backend-vm" {
  depends_on = [ module.backend-subnet ]
    source = "../module/4azurerm_virtual_machine"

      name            = "todo-backend-vm"
      location        = "southafricanorth"
      rg_name         = "dev-todo-rg"
      subnet_id       = module.backend-subnet.subnet_id
      admin_username  = data.azurerm_key_vault_secret.bakend_username.value
      admin_password  = data.azurerm_key_vault_secret.backend_password.value
}
################################################################################################

module "azurerm_sql_database" {
  depends_on = [ module.resource_groups ]
    source = "../module/5azurerm_sql_database"

      rg_name         = "dev-todo-rg"
      location        = "southafricanorth"
      admin_username  = data.azurerm_key_vault_secret.db_username.value
      admin_password  = data.azurerm_key_vault_secret.db_password.value
      name_db         = "todo-database1"
      sql_server_name = "todo-sql-server0071"
}

################################################################################################




