resource "azurerm_api_management" "this" {
  name                = "${local.prefix}-apim"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  publisher_name      = "Moritz Freyburger"
  publisher_email     = "moritz@freyburger.io"

  virtual_network_type = "External"

  virtual_network_configuration {
    subnet_id = azurerm_subnet.apis.id
  }

  sku_name = "Developer_1"

  depends_on = [
    azurerm_network_security_group.apim
  ]
}

resource "azurerm_api_management_policy" "this" {
  api_management_id = azurerm_api_management.this.id
  xml_content = templatefile("${path.module}/base-policy.xml", {
    frontdoor_id : azurerm_frontdoor.this.header_frontdoor_id
    backend_name : azurerm_api_management_backend.app.name
  })
}

resource "azurerm_api_management_api" "this" {
  name                = "Hello"
  resource_group_name = azurerm_resource_group.this.name
  api_management_name = azurerm_api_management.this.name
  revision            = "1"
  display_name        = "Hello API"
  path                = ""
  protocols           = ["https"]

  subscription_required = false
}

resource "azurerm_api_management_api_operation" "this" {
  operation_id        = "hello"
  api_name            = azurerm_api_management_api.this.name
  api_management_name = azurerm_api_management_api.this.api_management_name
  resource_group_name = azurerm_api_management_api.this.resource_group_name
  display_name        = "Hello"
  method              = "GET"
  url_template        = "/"
}

resource "azurerm_api_management_backend" "app" {
  name                = "app"
  resource_group_name = azurerm_resource_group.this.name
  api_management_name = azurerm_api_management.this.name

  protocol = "http"
  url      = "https://${azurerm_app_service.this.default_site_hostname}"
}
