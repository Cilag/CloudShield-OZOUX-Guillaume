resource "azurerm_virtual_network" "prod" {
  name                = "vnet-${var.project_name}-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = var.prod_vnet_cidr
  tags                = var.tags
}

resource "azurerm_subnet" "prod_web" {
  name                 = "snet-web"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = var.prod_web_subnet_cidr
}

resource "azurerm_subnet" "prod_app" {
  name                 = "snet-app"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = var.prod_app_subnet_cidr
}

resource "azurerm_subnet" "prod_db" {
  name                 = "snet-db"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = var.prod_db_subnet_cidr
}

resource "azurerm_subnet" "prod_private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = var.prod_private_endpoints_subnet_cidr

  private_endpoint_network_policies = "Disabled"
}
