# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
# Creamos una regla para permitir el acceso público mediante ssh a las máquinas virtuales

# Create a security group to allow connections from outside the Azure network
resource "azurerm_network_security_group" "sshSecGroup" {
    name                = "sshtraffic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    # Create a rule to allow SSH traffic to the node
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

# Create a security group to allow connections from outside the Azure network
resource "azurerm_network_security_group" "kubemasterSecGroup" {
    name                = "kubemastertraffic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    # Create a rule to allow SSH traffic to the node
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

    # Create a rule to allow the connections from outside to the kubernetes ports used by the ingress controller
    security_rule {
        name                       = "kubemaster ports"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "30000-32767"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "CP2"
    }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association

# Map the previously created security groups with all nodes
# We will use the ssh for all nodes and the other, with the kubernetes ports opened, only on the master nodes

 resource "azurerm_network_interface_security_group_association" "mastersSecGroupAssociation" {
    count                     = length(var.masters)
    network_interface_id      = azurerm_network_interface.mastersNic[count.index].id
    network_security_group_id = azurerm_network_security_group.kubemasterSecGroup.id
}

resource "azurerm_network_interface_security_group_association" "workersSecGroupAssociation" {
    count                     = length(var.workers)
    network_interface_id      = azurerm_network_interface.workersNic[count.index].id
    network_security_group_id = azurerm_network_security_group.sshSecGroup.id
}

resource "azurerm_network_interface_security_group_association" "nfsSecGroupAssociation" {
    count                     = length(var.nfs)
    network_interface_id      = azurerm_network_interface.nfsNic[count.index].id
    network_security_group_id = azurerm_network_security_group.sshSecGroup.id
}