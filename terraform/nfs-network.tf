# Creeate NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
# Creamos las interfaces de red para los nodos nfs

resource "azurerm_network_interface" "nfsNic" {
  count               = length(var.nfs)
  name                = "${var.nfs[count.index]}-Nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name                           = "${var.nfs[count.index]}-ipconfiguration"
        subnet_id                      = azurerm_subnet.kubeSubnet.id 
        private_ip_address_allocation  = "Static"
        private_ip_address             = "192.168.1.${105 + count.index}"
        public_ip_address_id           = azurerm_public_ip.nfsPublicIp[count.index].id
    }

    tags = {
        environment = "CP2"
    }

}

# IP pública
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
# Creamos una ip pública para cada uno de los nodos nfs

resource "azurerm_public_ip" "nfsPublicIp" {
  count               = length(var.nfs)
  name                = "${var.nfs[count.index]}-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }

}
