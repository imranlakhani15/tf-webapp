resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "West Europe"
}


provider "azurerm" {
  features {}
  subscription_id = "963841a7-3dc9-4433-95d1-64c6bc628837"
}


resource "azurerm_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "linux"
  sku_name            = "Standard"

}

resource "azurerm_app_service" "example" {
  name                = "tf-demo-im"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_service_plan.example.id

  site_config {
    dotnet_framework_version = "v6.0"
    scm_type                 = "LocalGit"
  }

  // ENV varibales
  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
