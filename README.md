# Sample repository for Azure Virtual Network integration

This repository showcases the use of [Private Endpoints](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview) in Azure Virtual Networks for App Services.

## Basic structure

* Front Door
  * Global access to the API Management
* API Management
  * External integration into VNET
* VNET
  * subnets + watcher + NSG
* Private DNS Zone
  * hostname/IP resolution
* App Service
  * Private Endpoint in VNET

## How to run

Make sure you have [Terraform](https://www.terraform.io/downloads.html) and [jq](https://stedolan.github.io/jq/) installed and you are logged in into the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) with a valid subscription. Then run `./run.sh` in Bash and enjoy the glory (it will take 45 minutes to apply).

> Don't forget to clean up afterwards by running `terraform destroy`.
