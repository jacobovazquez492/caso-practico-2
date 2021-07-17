# Creeate NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

# Create the network interface for the worker nodes
resource "azurerm_network_interface" "workersNic" {
  # We use the workers variable declared in the vars file to iterate and create all resources needed for all the worker nodes
  count               = length(var.workers)
  # Use the actual element of the worker variable to name this resource
  name                = "${var.workers[count.index]}-Nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        # Use the actual element of the worker variable to name this resource
        name                           = "${var.workers[count.index]}-ipconfiguration"
        # The ip will be allocated in the previous created subnet
        subnet_id                      = azurerm_subnet.kubeSubnet.id 
        private_ip_address_allocation  = "Static"
        # We will assign private ip's starting with the 110 one
        private_ip_address             = "192.168.1.${110 + count.index}"
        # Assing the public ip created in the next resource to the current worker item
        public_ip_address_id           = azurerm_public_ip.workersPublicIp[count.index].id
    }

    tags = {
        environment = "CP2"
    }

}

# IP pública
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
# Creamos una ip pública para cada uno de los nodos worker

resource "azurerm_public_ip" "workersPublicIp" {
  # We use the workers variable declared in the vars file to iterate and create all resources needed for all the worker nodes
  count               = length(var.workers)
  # Use the actual element of the worker variable to name this resource
  name                = "${var.workers[count.index]}-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  # We will use a dinamyc ip instead of a static one, it is cheaper
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }

}
