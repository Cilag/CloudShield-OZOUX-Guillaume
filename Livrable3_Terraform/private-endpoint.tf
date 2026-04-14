resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pe-stbackup-blob"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.prod_private_endpoints.id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-stbackup-blob"
    private_connection_resource_id = azurerm_storage_account.backups.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
}
