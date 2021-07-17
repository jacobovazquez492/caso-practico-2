# Creeate NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

# Create the network interface for the nfs nodes
resource "azurerm_network_interface" "nfsNic" {
  # We use the nfs variable declared in the vars file to iterate and create all resources needed for all the nfs nodes
  count               = length(var.nfs)
  # Use the actual element of the nfs variable to name this resource
  name                = "${var.nfs[count.index]}-Nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        # Use the actual element of the nfs variable to name this resource
        name                           = "${var.nfs[count.index]}-ipconfiguration"
        # The ip will be allocated in the previous created subnet
        subnet_id                      = azurerm_subnet.kubeSubnet.id 
        private_ip_address_allocation  = "Static"
        # We will assign private ip's starting with the 105 one
        private_ip_address             = "192.168.1.${105 + count.index}"
        # Assing the public ip created in the next resource to the current nfs item
        public_ip_address_id           = azurerm_public_ip.nfsPublicIp[count.index].id
    }

    tags = {
        environment = "CP2"
    }

}

# IP pública
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

# Create a public ip for each nfs node
resource "azurerm_public_ip" "nfsPublicIp" {
  # We use the nfs variable declared in the vars file to iterate and create all resources needed for all the nfs nodes
  count               = length(var.nfs)
  # Use the actual element of the nfs variable to name this resource
  name                = "${var.nfs[count.index]}-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  # We will use a dinamyc ip instead of a static one, it is cheaper
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }

}
