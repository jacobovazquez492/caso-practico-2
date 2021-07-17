# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

# Add the azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.1"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

# Create the resource group to organize all the created resoruces
resource "azurerm_resource_group" "rg" {
    name     =  "kubernetes_rg"
    location = var.location

    tags = {
        environment = "CP2"
    }

}

# Storage account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

# Storage account to save vm data in case of diagnosis
resource "azurerm_storage_account" "stAccount" {
    name                     = var.storage_account
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "CP2"
    }

}

# Cloud init config to create the adminUser and ansible user and to install python36 in all the vms's as an Ansible requirement
data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud_config.cfg")}"

  vars = {
    ssh_authorized_key = data.local_file.public_key.content
    adminUser = var.ssh_user
  }
}

# Load the public key to be used in the authorized keys by the cloud init configured users
data "local_file" "public_key" {
    filename = var.public_key_path
}
