# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.1"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

resource "azurerm_resource_group" "rg" {
    name     =  "kubernetes_rg"
    location = var.location

    tags = {
        environment = "CP2"
    }

}

# Storage account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

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

# configuracion de usuario y python36 con cloud_init
data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud_config.cfg")}"

  vars = {
    ssh_authorized_key = data.local_file.public_key.content
    adminUser = var.ssh_user
  }
}

data "local_file" "public_key" {
    filename = var.public_key_path
}

output "nfs_servers_public_ip_address" {
  description = "The actual publlic ip address allocated for the nfs servers."
  value       = azurerm_linux_virtual_machine.nfsVM[*].public_ip_address
}

output "masters_servers_public_ip_address" {
  description = "The actual publlic ip address allocated for the masters servers."
  value       = azurerm_linux_virtual_machine.mastersVM[*].public_ip_address
}

output "workers_servers_public_ip_address" {
  description = "The actual publlic ip address allocated for the workers servers."
  value       = azurerm_linux_virtual_machine.workersVM[*].public_ip_address
}
