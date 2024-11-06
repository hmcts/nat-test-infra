resource "azurerm_network_interface" "this" {
  name                = "${local.name}-nic"
  location            = module.networking.resource_group_location
  resource_group_name = module.networking.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = module.networking.subnet_ids["vnet-snet"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = module.ctags.common_tags
}

resource "azurerm_virtual_machine" "main" {
  name                             = "${local.name}-vm"
  location                         = module.networking.resource_group_location
  resource_group_name              = module.networking.resource_group_name
  network_interface_ids            = [azurerm_network_interface.this.id]
  vm_size                          = "Standard_D2ds_v5"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${local.name}-vm"
    admin_username = "admin_${random_string.username.result}"
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = module.ctags.common_tags
}
