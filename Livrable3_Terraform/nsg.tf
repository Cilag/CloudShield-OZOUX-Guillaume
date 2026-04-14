resource "azurerm_network_security_group" "web" {
  name                = "nsg-web"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "db" {
  name                = "nsg-db"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "private_endpoints" {
  name                = "nsg-private-endpoints"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

# ------------------------------------------------------------
# WEB NSG RULES
# ------------------------------------------------------------

resource "azurerm_network_security_rule" "web_in_ssh_from_bastion" {
  name                        = "allow-web-in-ssh-from-bastion"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.hub_bastion_subnet_cidr[0]
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.web.name
}

resource "azurerm_network_security_rule" "web_out_to_app" {
  name                                       = "allow-web-out-to-app"
  priority                                   = 100
  direction                                  = "Outbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "8080"
  resource_group_name                        = data.azurerm_resource_group.main.name
  network_security_group_name                = azurerm_network_security_group.web.name
  source_application_security_group_ids      = [azurerm_application_security_group.web.id]
  destination_application_security_group_ids = [azurerm_application_security_group.app.id]
}

resource "azurerm_network_security_rule" "web_out_to_db_deny" {
  name                                       = "deny-web-out-to-db"
  priority                                   = 110
  direction                                  = "Outbound"
  access                                     = "Deny"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "*"
  resource_group_name                        = data.azurerm_resource_group.main.name
  network_security_group_name                = azurerm_network_security_group.web.name
  source_application_security_group_ids      = [azurerm_application_security_group.web.id]
  destination_application_security_group_ids = [azurerm_application_security_group.db.id]
}

resource "azurerm_network_security_rule" "web_in_deny_vnet" {
  name                        = "deny-web-in-vnet"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.web.name
}

# ------------------------------------------------------------
# APP NSG RULES
# ------------------------------------------------------------

resource "azurerm_network_security_rule" "app_in_ssh_from_bastion" {
  name                        = "allow-app-in-ssh-from-bastion"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.hub_bastion_subnet_cidr[0]
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app.name
}

resource "azurerm_network_security_rule" "app_in_from_web" {
  name                                       = "allow-app-in-from-web"
  priority                                   = 110
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "8080"
  resource_group_name                        = data.azurerm_resource_group.main.name
  network_security_group_name                = azurerm_network_security_group.app.name
  source_application_security_group_ids      = [azurerm_application_security_group.web.id]
  destination_application_security_group_ids = [azurerm_application_security_group.app.id]
}

resource "azurerm_network_security_rule" "app_out_to_db" {
  name                                       = "allow-app-out-to-db"
  priority                                   = 100
  direction                                  = "Outbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "3306"
  resource_group_name                        = data.azurerm_resource_group.main.name
  network_security_group_name                = azurerm_network_security_group.app.name
  source_application_security_group_ids      = [azurerm_application_security_group.app.id]
  destination_application_security_group_ids = [azurerm_application_security_group.db.id]
}

resource "azurerm_network_security_rule" "app_out_to_private_endpoint" {
  name                        = "allow-app-out-to-private-endpoint"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = var.prod_private_endpoints_subnet_cidr[0]
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app.name
}

resource "azurerm_network_security_rule" "app_in_deny_vnet" {
  name                        = "deny-app-in-vnet"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app.name
}

# ------------------------------------------------------------
# DB NSG RULES
# ------------------------------------------------------------

resource "azurerm_network_security_rule" "db_in_ssh_from_bastion" {
  name                        = "allow-db-in-ssh-from-bastion"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.hub_bastion_subnet_cidr[0]
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.db.name
}

resource "azurerm_network_security_rule" "db_in_from_app" {
  name                                       = "allow-db-in-from-app"
  priority                                   = 110
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "3306"
  resource_group_name                        = data.azurerm_resource_group.main.name
  network_security_group_name                = azurerm_network_security_group.db.name
  source_application_security_group_ids      = [azurerm_application_security_group.app.id]
  destination_application_security_group_ids = [azurerm_application_security_group.db.id]
}

resource "azurerm_network_security_rule" "db_in_from_web_deny" {
  name                                       = "deny-db-in-from-web"
  priority                                   = 120
  direction                                  = "Inbound"
  access                                     = "Deny"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "*"
  resource_group_name                        = data.azurerm_resource_group.main.name
  network_security_group_name                = azurerm_network_security_group.db.name
  source_application_security_group_ids      = [azurerm_application_security_group.web.id]
  destination_application_security_group_ids = [azurerm_application_security_group.db.id]
}

resource "azurerm_network_security_rule" "db_out_to_private_endpoint" {
  name                        = "allow-db-out-to-private-endpoint"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = var.prod_private_endpoints_subnet_cidr[0]
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.db.name
}

resource "azurerm_network_security_rule" "db_in_deny_vnet" {
  name                        = "deny-db-in-vnet"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.db.name
}

# ------------------------------------------------------------
# ASSOCIATIONS NSG <-> SUBNETS
# ------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.prod_web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.prod_app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.prod_db.id
  network_security_group_id = azurerm_network_security_group.db.id
}

resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = azurerm_subnet.prod_private_endpoints.id
  network_security_group_id = azurerm_network_security_group.private_endpoints.id
}
