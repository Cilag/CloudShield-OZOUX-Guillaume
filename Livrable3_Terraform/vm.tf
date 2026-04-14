# =============================================================================
# VMs 3-Tiers : Web (nginx) / App (Python HTTP) / DB (MariaDB)
# Authentication par cle SSH - Ubuntu 22.04 LTS
# =============================================================================

# ------------------------------------------------------------
# NICs
# ------------------------------------------------------------

resource "azurerm_network_interface" "web" {
  name                = "nic-web-01"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig-web-01"
    subnet_id                     = azurerm_subnet.prod_web.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "app" {
  name                = "nic-app-01"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig-app-01"
    subnet_id                     = azurerm_subnet.prod_app.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "db" {
  name                = "nic-db-01"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig-db-01"
    subnet_id                     = azurerm_subnet.prod_db.id
    private_ip_address_allocation = "Dynamic"
  }
}

# ------------------------------------------------------------
# ASG Associations
# ------------------------------------------------------------

resource "azurerm_network_interface_application_security_group_association" "web" {
  network_interface_id          = azurerm_network_interface.web.id
  application_security_group_id = azurerm_application_security_group.web.id
}

resource "azurerm_network_interface_application_security_group_association" "app" {
  network_interface_id          = azurerm_network_interface.app.id
  application_security_group_id = azurerm_application_security_group.app.id
}

resource "azurerm_network_interface_application_security_group_association" "db" {
  network_interface_id          = azurerm_network_interface.db.id
  application_security_group_id = azurerm_application_security_group.db.id
}

# ------------------------------------------------------------
# VM Web - Tier 1 Presentation (nginx)
# ------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "web" {
  name                = "vm-web-01"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.web.id
  ]
  disable_password_authentication = true
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-web-01"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOT
    #cloud-config
    package_update: true
    packages:
      - nginx
    runcmd:
      - systemctl enable nginx
      - systemctl restart nginx
  EOT
  )
}

# ------------------------------------------------------------
# VM App - Tier 2 Traitement (Python HTTP server port 8080)
# ------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "app" {
  name                = "vm-app-01"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.app.id
  ]
  disable_password_authentication = true
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-app-01"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOT
    #cloud-config
    package_update: true
    packages:
      - python3
    write_files:
      - path: /etc/systemd/system/app-demo.service
        permissions: '0644'
        content: |
          [Unit]
          Description=Demo App on 8080
          After=network.target

          [Service]
          ExecStart=/usr/bin/python3 -m http.server 8080
          WorkingDirectory=/var/www/html
          Restart=always
          User=root

          [Install]
          WantedBy=multi-user.target
    runcmd:
      - mkdir -p /var/www/html
      - echo "app-tier-ok" > /var/www/html/index.html
      - systemctl daemon-reload
      - systemctl enable app-demo.service
      - systemctl restart app-demo.service
  EOT
  )
}

# ------------------------------------------------------------
# VM DB - Tier 3 Stockage (MariaDB)
# ------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "db" {
  name                = "vm-db-01"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.db.id
  ]
  disable_password_authentication = true
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-db-01"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOT
    #cloud-config
    package_update: true
    packages:
      - mariadb-server
    runcmd:
      - systemctl enable mariadb
      - systemctl restart mariadb
  EOT
  )
}
