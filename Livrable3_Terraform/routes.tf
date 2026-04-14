resource "azurerm_route_table" "web" {
  name                = "rt-web"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_route_table" "app" {
  name                = "rt-app"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_route_table" "db" {
  name                = "rt-db"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_subnet_route_table_association" "web" {
  subnet_id      = azurerm_subnet.prod_web.id
  route_table_id = azurerm_route_table.web.id
}

resource "azurerm_subnet_route_table_association" "app" {
  subnet_id      = azurerm_subnet.prod_app.id
  route_table_id = azurerm_route_table.app.id
}

resource "azurerm_subnet_route_table_association" "db" {
  subnet_id      = azurerm_subnet.prod_db.id
  route_table_id = azurerm_route_table.db.id
}

# Routes vers firewall - a activer quand un firewall ou NVA est deploye
# resource "azurerm_route" "web_default_to_firewall" {
#   name                   = "default-to-firewall"
#   resource_group_name    = data.azurerm_resource_group.main.name
#   route_table_name       = azurerm_route_table.web.name
#   address_prefix         = "0.0.0.0/0"
#   next_hop_type          = "VirtualAppliance"
#   next_hop_in_ip_address = "10.10.1.4"
# }
#
# resource "azurerm_route" "app_default_to_firewall" {
#   name                   = "default-to-firewall"
#   resource_group_name    = data.azurerm_resource_group.main.name
#   route_table_name       = azurerm_route_table.app.name
#   address_prefix         = "0.0.0.0/0"
#   next_hop_type          = "VirtualAppliance"
#   next_hop_in_ip_address = "10.10.1.4"
# }
#
# resource "azurerm_route" "db_default_to_firewall" {
#   name                   = "default-to-firewall"
#   resource_group_name    = data.azurerm_resource_group.main.name
#   route_table_name       = azurerm_route_table.db.name
#   address_prefix         = "0.0.0.0/0"
#   next_hop_type          = "VirtualAppliance"
#   next_hop_in_ip_address = "10.10.1.4"
# }
