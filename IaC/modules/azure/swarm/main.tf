variable "manager_count" { default = 1 }
variable "worker_count"  { default = 2 }
variable "vm_size"       { default = "Standard_B2s" }
variable "location"      { default = "East US" }
variable "ssh_public_key"   { description = "SSH public key" }
variable "ssh_private_key"  { description = "Path to SSH private key file" }
variable "admin_username"   { default = "azureuser" }

resource "azurerm_resource_group" "swarm" {
  name     = "swarm-rg"
  location = var.location
}

resource "azurerm_virtual_network" "swarm" {
  name                = "swarm-vnet"
  address_space       = ["10.11.0.0/16"]
  location            = azurerm_resource_group.swarm.location
  resource_group_name = azurerm_resource_group.swarm.name
}

resource "azurerm_subnet" "swarm" {
  name                 = "swarm-subnet"
  resource_group_name  = azurerm_resource_group.swarm.name
  virtual_network_name = azurerm_virtual_network.swarm.name
  address_prefixes     = ["10.11.1.0/24"]
}

resource "azurerm_network_interface" "manager" {
  count               = var.manager_count
  name                = "swarm-manager-nic-${count.index}"
  location            = azurerm_resource_group.swarm.location
  resource_group_name = azurerm_resource_group.swarm.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.swarm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.manager[count.index].id
  }
}

resource "azurerm_public_ip" "manager" {
  count               = var.manager_count
  name                = "swarm-manager-pubip-${count.index}"
  location            = azurerm_resource_group.swarm.location
  resource_group_name = azurerm_resource_group.swarm.name
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "manager" {
  count               = var.manager_count
  name                = "swarm-manager-${count.index}"
  resource_group_name = azurerm_resource_group.swarm.name
  location            = azurerm_resource_group.swarm.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.manager[count.index].id
  ]
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  custom_data = base64encode("#!/bin/bash
    apt-get update
    apt-get install -y docker.io
    docker swarm init --advertise-addr $(hostname -I | awk '{print $1}')
  ")
}

output "manager_public_ip" {
  value = azurerm_public_ip.manager[0].ip_address
}