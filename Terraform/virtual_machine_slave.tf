resource "azurerm_linux_virtual_machine" "module5_vm_slave" {
  name                  = "module5_vm_slave"
  location              = azurerm_resource_group.slave_controller.location
  resource_group_name   = azurerm_resource_group.slave_controller.name
  network_interface_ids = [azurerm_network_interface.module5_nic_slave.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "slave"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.ssh-pkey.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vms_shutdown" {
  virtual_machine_id = azurerm_linux_virtual_machine.module5_vm_slave.id
  location           = azurerm_resource_group.slave_controller.location
  enabled            = true

  daily_recurrence_time = "1730"
  timezone              = "GMT Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    email           = "noveed.muhammed@hse.gov.uk"
  }
  depends_on = [azurerm_linux_virtual_machine.module5_vm_slave, tls_private_key.ssh-pkey]
}