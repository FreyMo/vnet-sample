output "frontdoor_url" {
  value = "https://${azurerm_frontdoor.this.cname}"
}
