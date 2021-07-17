# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

# Create the network to by used by the kubernetes nodes
resource "azurerm_virtual_network" "kubeNet" {
    name                = "kubernetesnet"
    # The network spaces to create subnets
    address_space       = ["192.168.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = "CP2"
    }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

# Create the subnet inside the previous network to by used by the kubernetes nodes
resource "azurerm_subnet" "kubeSubnet" {
    name                   = "kubernetessubnet"
    resource_group_name    = azurerm_resource_group.rg.name
    virtual_network_name   = azurerm_virtual_network.kubeNet.name
    # All the private node ip's  will by created in this subnate address
    address_prefixes       = ["192.168.1.0/24"]
}
