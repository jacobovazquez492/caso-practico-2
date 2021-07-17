# Creeate NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

# Create the network interface for the master nodes
resource "azurerm_network_interface" "mastersNic" {
  # We use the masters variable declared in the vars file to iterate and create all resources needed for all the master nodes
  count               = length(var.masters)
  # Use the actual element of the masters variable to name this resource
  name                = "${var.masters[count.index]}-Nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    # Create an internal ip for the master nodes
    ip_configuration {
        # Use the actual element of the masters variable to name this resource
        name                           = "${var.masters[count.index]}-ipconfiguration"
        # The ip will be allocated in the previous created subnet
        subnet_id                      = azurerm_subnet.kubeSubnet.id 
        private_ip_address_allocation  = "Static"
        # We will assign private ip's starting with the 100 one
        private_ip_address             = "192.168.1.${100 + count.index}"
        # Assing the public ip created in the next resource to the current master item
        public_ip_address_id           = azurerm_public_ip.mastersPublicIp[count.index].id
    }

    tags = {
        environment = "CP2"
    }

}

# IP pública
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

# Create a public ip for each master node
resource "azurerm_public_ip" "mastersPublicIp" {
  # We use the masters variable declared in the vars file to iterate and create all resources needed for all the master nodes
  count               = length(var.masters)
  # Use the actual element of the masters variable to name this resource
  name                = "${var.masters[count.index]}-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  # We will use a dinamyc ip instead of a static one, it is cheaper
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }

}
