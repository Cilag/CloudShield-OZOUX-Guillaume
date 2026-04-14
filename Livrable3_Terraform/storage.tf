resource "random_string" "storage" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_storage_account" "backups" {
  name                            = "stbackup${random_string.storage.result}"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}
