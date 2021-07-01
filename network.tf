resource "azurerm_virtual_network" "this" {
  name                = "${local.prefix}-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.0.0.0/16"]

  depends_on = [
    azurerm_network_watcher.this
  ]
}

resource "azurerm_subnet" "apis" {
  name                 = "Apis"
  virtual_network_name = azurerm_virtual_network.this.name
  resource_group_name  = azurerm_resource_group.this.name
  address_prefixes     = ["10.0.0.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ApiManagement/service"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
      ]
    }
  }
}

resource "azurerm_network_security_group" "apim" {
  name                = "${local.prefix}-nsg"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_network_security_rule" "apim" {
  name                        = "AllowApiManagementServiceInbound"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.apim.name
  description                 = "Allows inbound access to the API Management Service API"
  access                      = "Allow"
  direction                   = "Inbound"
  protocol                    = "Tcp"
  source_address_prefix       = "ApiManagement"
  destination_address_prefix  = "VirtualNetwork"
  source_port_range           = "*"
  destination_port_range      = 3443
  priority                    = 110
}

resource "azurerm_subnet" "apps" {
  name                 = "Apps"
  virtual_network_name = azurerm_virtual_network.this.name
  resource_group_name  = azurerm_resource_group.this.name
  address_prefixes     = ["10.0.2.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_network_watcher" "this" {
  name                = "${local.prefix}-nw"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
