output "vnet_rg_id" {
  value = azurerm_resource_group.vnet_rg.id
  description = "Azure Resource Group id for network resources."
}

output "vnet_nsg_id" {
  value = azurerm_network_security_group.vnet_nsg.id
  description = "Azure Network Security Group id for network resources."
}

output "virtual_network_id" {
  value = azurerm_virtual_network.virtual_network.id
  description = "Azure VNET id for network resources."
}

output "virtual_network_name" {
  value = azurerm_virtual_network.virtual_network.name
  description = "Azure VNET name."
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
  value = azurerm_local_network_gateway.ptp_vpn_local_gw.id
  description = "Azure Local Gateway id for VPN."
  depends_on = [azurerm_local_network_gateway.ptp_vpn_local_gw]
}