provider "azurerm" {
  features {
  }
  subscription_id = "97e28a08-1486-4615-b314-1e2827c922e0"
}

resource "azurerm_storage_account" "storage_account" {
  name                      = "ythieltfauthcheckstorage"
  location                  = var.location
  resource_group_name       = "ythiel-test-gateway"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  https_traffic_only_enabled = true
  min_tls_version           = "TLS1_2"
  tags                      = var.tags
}

resource "azurerm_app_service_plan" "function_asp" {
  name                = "ythieltfauthcheck-function-asp"
  location            = var.location
  resource_group_name = "ythiel-test-gateway"
  kind                = "FunctionApp"
  reserved            = true
  tags                = var.tags

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = "ythieltfauthcheck-functions"
  location                   = var.location
  resource_group_name        = "ythiel-test-gateway"
  app_service_plan_id        = azurerm_app_service_plan.function_asp.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  https_only                 = true
  os_type                    = "linux"
  version                    = "~4"
  tags                       = {
    "hidden-link: /app-insights-conn-string"         = "InstrumentationKey=44f1d2db-18da-4604-a28a-988853c03e0d;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/;ApplicationId=e2204bb6-b3d2-41aa-aa21-7d412776e925"
    "hidden-link: /app-insights-instrumentation-key" = "44f1d2db-18da-4604-a28a-988853c03e0d"
    "hidden-link: /app-insights-resource-id"         = "/subscriptions/97e28a08-1486-4615-b314-1e2827c922e0/resourceGroups/ythiel-test-gateway/providers/microsoft.insights/components/ythieltfauthcheck-functions"
    "owner"                                          = "maintainer@organization.com"
  }

  site_config {
    linux_fx_version = "Python|3.11"
    use_32_bit_worker_process        = false
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = "44f1d2db-18da-4604-a28a-988853c03e0d"
    APPLICATIONINSIGHTS_CONNECTION_STRING = "InstrumentationKey=44f1d2db-18da-4604-a28a-988853c03e0d;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/;ApplicationId=e2204bb6-b3d2-41aa-aa21-7d412776e925"
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
    MY_VARIABLE = "env_variable"
  }
}

# Generate deploy script
resource "local_file" "deploy_azure_function" {
  filename = "${path.module}/../scripts/deploy_function_app.sh"
  content  = <<-CONTENT
    zip -r build/function_app.zip \
    app/ function/ host.json requirements.txt \
    -x '*__pycache__*' \

   az functionapp deployment source config-zip \
    --resource-group ythiel-test-gateway \
    --name ${azurerm_function_app.function_app.name} \
    --src build/function_app.zip \
    --build-remote true \
    --verbose
  CONTENT
}