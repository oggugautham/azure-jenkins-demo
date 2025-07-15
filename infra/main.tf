resource "azurerm_resource_group" "rg" {
  name     = "demo-ci"
  location = "Canada Central"
}

resource "azurerm_storage_account" "sa" {
  name                     = "democistorage${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}