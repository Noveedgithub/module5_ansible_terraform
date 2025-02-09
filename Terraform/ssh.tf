resource "tls_private_key" "ssh-pkey" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  filename        = "${path.module}/private_key_master.pem"
  content         = tls_private_key.ssh-pkey.private_key_pem
  file_permission = "0600"
}


resource "azurerm_ssh_public_key" "ssh_key" {
  name                = "ssh-key"
  location            = azurerm_resource_group.master_controller.location
  resource_group_name = azurerm_resource_group.master_controller.name
  public_key          = tls_private_key.ssh-pkey.public_key_openssh
}

