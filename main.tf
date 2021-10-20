# prepare terraform provider version
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.73.0"
    }
  }
}

# Configuration local to Azure(service connection)
# service principals

provider "azurerm" {
  features {}

  # More information on the authentication methods supported by
  # the AzureRM  Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

  subscription_id = "65911ece-b772-4e16-ab25-fc95982846dc"
   client_id = "37f075a8-9437-4317-84e7-8106b3c2c6a3"
   client_secret = "ui8lG0EanXUt.M3ZM-T8P8krICoaEk.RS6"
   tenant_id  = "8a38d5c9-ff2f-479e-8637-d73f6241a4f0"
}

resource "azurerm_resource_group" "rgsai" {
  name     = "rgsai999"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "freeplan" {
  name                = "freeplan1"
  location            = azurerm_resource_group.rgsai.location
  resource_group_name = azurerm_resource_group.rgsai.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "myapp6677" {
  name                = "myapp99989"
  location            = azurerm_resource_group.rgsai.location
  resource_group_name = azurerm_resource_group.rgsai.name
  app_service_plan_id = azurerm_app_service_plan.freeplan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}