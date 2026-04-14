resource "azurerm_virtual_network_peering" "hub_to_prod" {
  name                         = "peer-hub-to-prod"
  resource_group_name          = data.azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.prod.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false

  depends_on = [
    azurerm_subnet.hub_firewall,
    azurerm_subnet.hub_gateway,
    azurerm_subnet.hub_bastion,
    azurerm_subnet.hub_shared_services,
    azurerm_subnet.prod_web,
    azurerm_subnet.prod_app,
    azurerm_subnet.prod_db,
    azurerm_subnet.prod_private_endpoints
  ]
}

resource "azurerm_virtual_network_peering" "prod_to_hub" {
  name                         = "peer-prod-to-hub"
  resource_group_name          = data.azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.prod.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false

  depends_on = [
    azurerm_subnet.hub_firewall,
    azurerm_subnet.hub_gateway,
    azurerm_subnet.hub_bastion,
    azurerm_subnet.hub_shared_services,
    azurerm_subnet.prod_web,
    azurerm_subnet.prod_app,
    azurerm_subnet.prod_db,
    azurerm_subnet.prod_private_endpoints
  ]
}
