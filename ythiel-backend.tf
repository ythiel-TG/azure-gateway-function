#backend "azurerm" {
#  resource_group_name  = "ythiel-test-gateway"
#  storage_account_name = "ythiel-tfstatetestacct"
#  container_name       = "ythiel-tfstatetestcontainer"
#  key                  = "test-function-app/terraform.tfstate"
#  subscription_id      = "114b3077-7882-4c30-8494-97b378358c52"
#}
#required_providers {
#  azurerm = {
#    source  = "hashicorp/azurerm"
#    version = "=3.98.0"
#  }
#  local = {
#    source  = "hashicorp/local"
#    version = "~> 2.1"
#  }
#}
