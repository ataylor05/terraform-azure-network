variable "environment_tag" {
    type = string
    default = "NPE"
    description = "The type of environment."
}

variable "vnet_name" {
    type = string
    default = "Demo-VNET"
    description = "The name for the Azure VNET."
}

variable "vnet_cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "The CIDR address for the Azure VNET."
}

variable "region" {
    type = string
    default = "EastUS"
    description = "The Azure region the VNET will be placed in."
}

variable "public_subnet_name" {
    type = string
    default = "public"
    description = "The name for the public facing subnet in the VNET."
}

variable "public_subnet" {
    type = string
    default = "10.0.0.0/24"
    description = "The CIDR block for the public subnet."
}

variable "app_subnet_name" {
    type = string
    default = "app"
    description = "The name for the application subnet in the VNET."
}

variable "app_subnet" {
    type = string
    default = "10.0.1.0/24"
    description = "The CIDR block for the application subnet."
}

variable "data_subnet_name" {
    type = string
    default = "data"
    description = "The name for the data subnet in the VNET."
}

variable "data_subnet" {
    type = string
    default = "10.0.2.0/24"
    description = "The CIDR block for the data subnet."
}

variable "mgmt_subnet_name" {
    type = string
    default = "mgmt"
    description = "The name for the management subnet in the VNET."
}

variable "mgmt_subnet" {
    type = string
    default = "10.0.3.0/24"
    description = "The CIDR block for the management subnet."
}

variable "gateway_subnet" {
    type = string
    default = "10.0.255.0/24"
    description = "The CIDR block for the VPN subnet."
}

variable "enable_ptp_vpn" {
    type = bool
    default = false
    description = "Enables a point to point VPN on the VNET, requires additional variables with a ptp_vpn_ prefix."
}

variable "ptp_vpn_remote_gw_name" {
    type = string
    default = "New York Office 1"
    description = "OPTIONAL: A name for the remote gateway."
}

variable "ptp_vpn_remote_endpoint" {
    type = string
    default = "12.13.14.15"
    description = "OPTIONAL: The IP address of the remote VPN endpoint."
}

variable "ptp_vpn_remote_network" {
    type = string
    default = "192.168.0.0/24"
    description = "OPTIONAL: The CIDR block of the remote network."
}