resource "azurerm_frontdoor" "this" {
  name                                         = "${local.prefix}-fd"
  resource_group_name                          = azurerm_resource_group.this.name
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "default-routing-rule"
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["default-frontend-endpoint"]

    forwarding_configuration {
      forwarding_protocol = "HttpsOnly"
      backend_pool_name   = "api-management"
    }
  }

  backend_pool {
    name                = "api-management"
    health_probe_name   = "default-health-probe"
    load_balancing_name = "default-load-balancing"

    backend {
      host_header = "${local.prefix}-apim.azure-api.net"
      address     = "${local.prefix}-apim.azure-api.net"
      http_port   = 80
      https_port  = 443
    }
  }

  backend_pool_health_probe {
    name = "default-health-probe"
  }

  backend_pool_load_balancing {
    name = "default-load-balancing"
  }

  frontend_endpoint {
    name      = "default-frontend-endpoint"
    host_name = "${local.prefix}-fd.azurefd.net"
  }

  depends_on = [
    azurerm_network_security_group.apim
  ]
}
