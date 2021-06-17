# Security group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group

resource "azurerm_network_security_group" "sshSecGroup" {
    name                = "sshtraffic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "CP2"
    }
}

# Vinculamos el security group al interface de red
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association

resource "azurerm_network_interface_security_group_association" "mastersSecGroupAssociation" {
    count                     = length(var.masters)
    network_interface_id      = azurerm_network_interface.mastersNic[count.index].id
    network_security_group_id = azurerm_network_security_group.sshSecGroup.id
}

resource "azurerm_network_interface_security_group_association" "workersSecGroupAssociation" {
    count                     = length(var.workers)
    network_interface_id      = azurerm_network_interface.workersNic[count.index].id
    network_security_group_id = azurerm_network_security_group.sshSecGroup.id
}
