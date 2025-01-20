# Network Security Group
resource "azurerm_network_security_group" "module5_nsg_master" {
  name                = "module5_nsg_master"
  location            = azurerm_resource_group.master_controller.location
  resource_group_name = azurerm_resource_group.master_controller.name


  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
