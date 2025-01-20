# Virtual network
resource "azurerm_virtual_network" "module5_vnet_slave" {
  name                = "module5_vnet_slave"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.slave_controller.location
  resource_group_name = azurerm_resource_group.slave_controller.name
}

resource "azurerm_subnet" "module5-subnet_slave" {
  name                 = "module5-subnet_slave"
  resource_group_name  = azurerm_resource_group.slave_controller.name
  virtual_network_name = azurerm_virtual_network.module5_vnet_slave.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP - slave
resource "azurerm_public_ip" "module5_public_ip_slave" {
  name                = "module5_public_ip_slave"
  location            = azurerm_resource_group.slave_controller.location
  resource_group_name = azurerm_resource_group.slave_controller.name
  allocation_method   = "Dynamic"
}

# Network Interface - slave
resource "azurerm_network_interface" "module5_nic_slave" {
  name                = "module5_nic_slave"
  location            = azurerm_resource_group.slave_controller.location
  resource_group_name = azurerm_resource_group.slave_controller.name

  ip_configuration {
    name                          = "module5_nic_slave_configuration"
    subnet_id                     = azurerm_subnet.module5-subnet_slave.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.module5_public_ip_slave.id
  }
}

# Connect NSG to the network interface - slave
resource "azurerm_network_interface_security_group_association" "NSG2NI_slave" {
  network_interface_id      = azurerm_network_interface.module5_nic_slave.id
  network_security_group_id = azurerm_network_security_group.module5_nsg_slave.id
}