#!/bin/bash

terraform init
terraform apply <<< yes

frontdoor_url=$(terraform output -json | jq -r '.frontdoor_url.value')

start $frontdoor_url
