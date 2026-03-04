resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-cp2"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet_cp2"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name

  address_prefixes = ["10.0.1.0/24"]
}