provider "azurerm" {
    version = "3.10.0"
    features {}
}
#backend for tfstate
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform_RG"
    storage_account_name = "naggysstorageacc"
    container_name       = "tfstatecontainer"
    key = "terraform2.tfstate"


  }

}
#variables
variable "location" {
    default = "East Us"
  
}

variable "prefix" {
    default = "terraform_RG"
  
}
#resources
// resource "azurerm_resource_group" "example" {
//   name     = "terraform_RG"
//   location = "East Us"
// }

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.prefix
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.prefix
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.prefix

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = var.prefix
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"



  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
