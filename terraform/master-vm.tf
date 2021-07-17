# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

# Create the vm for the master nodes
resource "azurerm_linux_virtual_machine" "mastersVM" {
    # We use the masters variable declared in the vars file to iterate and create all resources needed for all the master nodes
    count               = length(var.masters)
    # Use the actual element of the masters variable to name this resource
    name                = "${var.masters[count.index]}"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    # Use the machine type declared in vars file for master nodes to create this vm
    size                = var.vm_masters_size
    admin_username      = var.ssh_user
    # Assing the nic created for this vm
    network_interface_ids = [ azurerm_network_interface.mastersNic[count.index].id ]
    disable_password_authentication = true

    # Add the cloud config information to the node
    custom_data = base64encode(data.template_file.cloud_config.rendered)

    # SSH user and key to secure the connections to the node
    admin_ssh_key {
        username   = var.ssh_user
        public_key = file(var.public_key_path)
    }

    # Assign a standard read / write disk to the node
    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    
    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    # The OS image used to create the vm. Requires prior acceptance of the license
    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    # Add the storage account created for debugging to the virtual machine
    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
    }

    tags = {
        environment = "CP2"
    }

}
