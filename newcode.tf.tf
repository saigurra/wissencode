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

resource "azurerm_resource_group" "rggood" {
  name     = "rggood123"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet123"
  resource_group_name = azurerm_resource_group.rggood.name
  location            = azurerm_resource_group.rggood.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sub" {
  name                 = "mysub"
  resource_group_name  = azurerm_resource_group.rggood.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_windows_virtual_machine_scale_set" "vmsc" {
  name                = "vmss"
  resource_group_name = azurerm_resource_group.rggood.name
  location            = azurerm_resource_group.rggood.location
  sku                 = "Standard_F2"
  instances           = 2
  admin_password      = "P@55w0rd1234!"
  admin_username      = "adminuser"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name      = "myip"
      primary   = true
      subnet_id = azurerm_subnet.sub.id
    }
  }
}