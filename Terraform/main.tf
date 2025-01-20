# Resource Group
resource "azurerm_resource_group" "master_controller" {
  location = var.resource_group_location
  name     = var.resource_group_name_master
}

resource "azurerm_resource_group" "slave_controller" {
  location = var.resource_group_location
  name     = var.resource_group_name_slave
}

resource "azurerm_resource_group" "k8s" {
  location = var.resource_group_location
  name     = var.resource_group_name_k8s
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.master_controller.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.master_controller.location
  resource_group_name      = azurerm_resource_group.master_controller.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}