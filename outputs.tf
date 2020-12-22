output "network_rg_id" {
  value = azurerm_resource_group.network_rg.id
  description = "Azure Resource Group id for network resources."
}

output "vnet_public_nsg_id" {
  value = azurerm_network_security_group.vnet_public_nsg.id
  description = "Azure Network Security Group id for public in-bound traffic."
}

output "virtual_network_id" {
  value = azurerm_virtual_network.virtual_network.id
  description = "Azure VNET id for network resources."
}

output "virtual_network_name" {
  value = azurerm_virtual_network.virtual_network.name
  description = "Azure VNET name."
}

output "virtual_network_route_table" {
  value = azurerm_route_table.vnet_route_table.id
  description = "Azure VNET Route Table id."
}

output "public_subnet_id" {
  value = azurerm_subnet.public_subnet.id
  description = "Azure subnet id for the public subnet."
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
  description = "Azure subnet id for the app subnet."
}

output "data_subnet_id" {
  value = azurerm_subnet.data_subnet.id
  description = "Azure subnet id for the data subnet."
}

output "mgmt_subnet_id" {
  value = azurerm_subnet.mgmt_subnet.id
  description = "Azure subnet id for the management subnet."
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_subnet.id
  description = "Azure subnet id for the VPN subnet."
}

output "ptp_vpn_local_gw_id" {
  value = azurerm_local_network_gateway.ptp_vpn_local_gw[*].id
  description = "Azure Local Gateway id for VPN."
  depends_on = [azurerm_local_network_gateway.ptp_vpn_local_gw]
}

output "ptp_vpn_virtual_gw_id" {
  value = azurerm_virtual_network_gateway.virtual_network_gateway[*].id
  description = "Azure Virtual Netowrk Gateway id for VPN."
  depends_on = [azurerm_virtual_network_gateway.virtual_network_gateway]
}

output "ptp_vpn_virtual_gw_ip" {
  value = azurerm_public_ip.virtual_network_gateway_public_ip[*].ip_address
  description = "Azure Virtual Netowrk Gateway ip for VPN."
  depends_on = [azurerm_virtual_network_gateway.virtual_network_gateway]
}