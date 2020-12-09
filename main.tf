provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vnet_rg" {
  name     = "${var.environment_tag}-${var.region}-Network-RG"
  location = var.region

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_security_group" "vnet_nsg" {
  name                = "${var.vnet_name}-Public-Inbound-NSG"
  location            = var.region
  resource_group_name = azurerm_resource_group.vnet_rg.name

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name          = var.vnet_name
  address_space = [var.vnet_cidr]
  location      = var.region
  resource_group_name = azurerm_resource_group.vnet_rg.name

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_subnet" "public_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = var.public_subnet_name
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.public_subnet
}

resource "azurerm_subnet" "app_subnet" {
  depends_on                = [azurerm_subnet.public_subnet]
  name                      = var.app_subnet_name
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.app_subnet
}

resource "azurerm_subnet" "data_subnet" {
  depends_on                = [azurerm_subnet.app_subnet]
  name                      = var.data_subnet_name
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.data_subnet
}

resource "azurerm_subnet" "mgmt_subnet" {
  depends_on                = [azurerm_subnet.data_subnet]
  name                      = var.mgmt_subnet_name
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.mgmt_subnet
}

resource "azurerm_subnet" "gateway_subnet" {
  depends_on                = [azurerm_subnet.mgmt_subnet]
  name                      = "GatewaySubnet"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.gateway_subnet
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  depends_on                = [azurerm_subnet.gateway_subnet]
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.vnet_nsg.id
}

resource "azurerm_local_network_gateway" "ptp_vpn_local_gw" {
  count               = var.enable_ptp_vpn == true ? 1 : 0
  depends_on          = [azurerm_virtual_network.virtual_network]
  name                = var.ptp_vpn_remote_gw_name
  resource_group_name = azurerm_resource_group.vnet_rg.name
  location            = var.region
  gateway_address     = var.ptp_vpn_remote_endpoint
  address_space       = [var.ptp_vpn_remote_network]
}