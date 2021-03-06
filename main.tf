provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "network_rg" {
  name     = "${var.environment_tag}-${var.region}-Network-RG"
  location = var.region

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_security_group" "vnet_public_nsg" {
  name                = "${var.environment_tag}-${var.region}-${var.vnet_name}-Public-Inbound-NSG"
  location            = var.region
  resource_group_name = azurerm_resource_group.network_rg.name

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name          = "${var.environment_tag}-${var.region}-${var.vnet_name}"
  address_space = [var.vnet_cidr]
  location      = var.region
  resource_group_name = azurerm_resource_group.network_rg.name

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_route_table" "vnet_route_table" {
  name                          = "${var.environment_tag}-${var.region}-${var.vnet_name}-RT"
  location                      = var.region
  resource_group_name           = azurerm_resource_group.network_rg.name
  disable_bgp_route_propagation = false

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_route" "route_to_internet" {
  name                = "Internet"
  resource_group_name = azurerm_resource_group.network_rg.name
  route_table_name    = azurerm_route_table.vnet_route_table.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

resource "azurerm_route" "route_to_local_vnet" {
  name                = "LocalVNET"
  resource_group_name = azurerm_resource_group.network_rg.name
  route_table_name    = azurerm_route_table.vnet_route_table.name
  address_prefix      = var.vnet_cidr
  next_hop_type       = "VnetLocal"
}

resource "azurerm_subnet" "public_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = var.public_subnet_name
  resource_group_name       = azurerm_resource_group.network_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.public_subnet]
}

resource "azurerm_subnet_route_table_association" "public_subnet_route_table_association" {
  subnet_id      = azurerm_subnet.public_subnet.id
  route_table_id = azurerm_route_table.vnet_route_table.id
}

resource "azurerm_subnet" "app_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = var.app_subnet_name
  resource_group_name       = azurerm_resource_group.network_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.app_subnet]
}

resource "azurerm_subnet_route_table_association" "app_subnet_route_table_association" {
  subnet_id      = azurerm_subnet.app_subnet.id
  route_table_id = azurerm_route_table.vnet_route_table.id
}

resource "azurerm_subnet" "data_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = var.data_subnet_name
  resource_group_name       = azurerm_resource_group.network_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.data_subnet]
}

resource "azurerm_subnet_route_table_association" "data_subnet_route_table_association" {
  subnet_id      = azurerm_subnet.data_subnet.id
  route_table_id = azurerm_route_table.vnet_route_table.id
}

resource "azurerm_subnet" "mgmt_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = var.mgmt_subnet_name
  resource_group_name       = azurerm_resource_group.network_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.mgmt_subnet]
}

resource "azurerm_subnet_route_table_association" "mgmt_subnet_route_table_association" {
  subnet_id      = azurerm_subnet.mgmt_subnet.id
  route_table_id = azurerm_route_table.vnet_route_table.id
}

resource "azurerm_subnet" "gateway_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = "GatewaySubnet"
  resource_group_name       = azurerm_resource_group.network_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.gateway_subnet]
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.vnet_public_nsg.id
}

resource "azurerm_local_network_gateway" "ptp_vpn_local_gw" {
  count               = var.enable_ptp_vpn == true ? 1 : 0
  name                = var.ptp_vpn_remote_gw_name
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = var.region
  gateway_address     = var.ptp_vpn_remote_endpoint
  address_space       = [var.ptp_vpn_remote_network]

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_public_ip" "virtual_network_gateway_public_ip" {
  count               = var.enable_ptp_vpn == true ? 1 : 0
  name                = "${var.environment_tag}-${var.region}-${var.vnet_name}-PTP-VPN-IP"
  location            = var.region
  resource_group_name = azurerm_resource_group.network_rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  depends_on          = [azurerm_subnet_route_table_association.public_subnet_route_table_association,azurerm_subnet_route_table_association.app_subnet_route_table_association,azurerm_subnet_route_table_association.data_subnet_route_table_association,azurerm_subnet_route_table_association.data_subnet_route_table_association,azurerm_subnet_route_table_association.mgmt_subnet_route_table_association]
  count               = var.enable_ptp_vpn == true ? 1 : 0
  name                = "${var.environment_tag}-${var.region}-${var.vnet_name}-PTP-VPN-GW"
  location            = var.region
  resource_group_name = azurerm_resource_group.network_rg.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  enable_bgp          = false
  sku                 = var.virtual_network_gateway_sku

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.virtual_network_gateway_public_ip[count.index].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  count                      = var.enable_ptp_vpn == true ? 1 : 0
  depends_on                 = [azurerm_virtual_network_gateway.virtual_network_gateway]
  name                       = "${var.environment_tag}-${var.region}-${var.vnet_name}-PTP-VPN-GW-Connections"
  location                   = var.region
  resource_group_name        = azurerm_resource_group.network_rg.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.virtual_network_gateway[count.index].id
  local_network_gateway_id   = azurerm_local_network_gateway.ptp_vpn_local_gw[count.index].id
  shared_key                 = var.ptp_vpn_psk

  ipsec_policy {
    ike_encryption   = var.ptp_vpn_ike_encryption
    ike_integrity    = var.ptp_vpn_ike_integrity
    dh_group         = var.ptp_vpn_dh_group
    ipsec_encryption = var.ptp_vpn_ipsec_encryption
    ipsec_integrity  = var.ptp_vpn_ipsec_integrity
    pfs_group        = var.ptp_vpn_pfs_group
    sa_lifetime      = var.ptp_vpn_sa_lifetime
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_route" "vpn_route" {
  count               = var.enable_ptp_vpn == true ? 1 : 0
  depends_on          = [azurerm_virtual_network_gateway.virtual_network_gateway]
  name                = "VPNRoute"
  resource_group_name = azurerm_resource_group.network_rg.name
  route_table_name    = azurerm_route_table.vnet_route_table.name
  address_prefix      = var.ptp_vpn_remote_network
  next_hop_type       = "VirtualNetworkGateway"
}