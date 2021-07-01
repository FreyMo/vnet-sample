resource "azurerm_app_service_plan" "this" {
  name                = "${local.prefix}-asp"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  kind                = "linux"
  reserved            = true

  sku {
    tier = "PremiumV2"
    size = "P1v2"
  }
}

resource "azurerm_app_service" "this" {
  name                = "${local.prefix}-as"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = azurerm_app_service_plan.this.id

  site_config {
    linux_fx_version = "DOCKER|nginxdemos/hello:0.2"
  }
}

resource "azurerm_private_endpoint" "this" {
  name                = "${local.prefix}-apps-endpoint"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.apps.id

  private_service_connection {
    name                           = "apps-serviceconnection"
    private_connection_resource_id = azurerm_app_service.this.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}
