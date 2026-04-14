output "resource_group_name" {
  value = data.azurerm_resource_group.main.name
}

output "resource_group_location" {
  value = data.azurerm_resource_group.main.location
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "prod_vnet_name" {
  value = azurerm_virtual_network.prod.name
}

output "prod_web_subnet_id" {
  value = azurerm_subnet.prod_web.id
}

output "prod_app_subnet_id" {
  value = azurerm_subnet.prod_app.id
}

output "prod_db_subnet_id" {
  value = azurerm_subnet.prod_db.id
}

output "prod_private_endpoints_subnet_id" {
  value = azurerm_subnet.prod_private_endpoints.id
}

output "asg_web_id" {
  value = azurerm_application_security_group.web.id
}

output "asg_app_id" {
  value = azurerm_application_security_group.app.id
}

output "asg_db_id" {
  value = azurerm_application_security_group.db.id
}

output "vm_web_private_ip" {
  value = azurerm_network_interface.web.private_ip_address
}

output "vm_app_private_ip" {
  value = azurerm_network_interface.app.private_ip_address
}

output "vm_db_private_ip" {
  value = azurerm_network_interface.db.private_ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.backups.name
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion.ip_address
}
