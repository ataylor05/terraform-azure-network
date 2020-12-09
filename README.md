# terraform-azure-network
Terraform module to build network layer in Azure.  This module is intended to be used in Terraform Cloud and stored in a private registry.

## Module examples
Simple example<br>
<pre>
module "network" {
    source  = "app.terraform.io/ANET/network/azure"
    version = "1.0.0"

    region              = "EastUS"
    vnet_name           = "demo-vnet"
    vnet_cidr           = "10.0.0.0/16"
    
    public_subnet_name  = "public"
    public_subnet       = "10.0.0.0/24"
    
    app_subnet_name     = "app"
    app_subnet          = "10.0.1.0/24"

    data_subnet_name    = "data"
    data_subnet         = "10.0.2.0/24"

    mgmt_subnet_name    = "mgmt"
    mgmt_subnet         = "10.0.3.0/24"

    gateway_subnet      = "10.0.255.0/24"
}
</pre><br><br>

With Point to Point VPN<br>
<pre>
module "network" {
    source                  = "app.terraform.io/ANET/network/azure"
    version                 = "1.0.0"

    region                  = "EastUS"
    vnet_name               = "demo-vnet"
    vnet_cidr               = "10.0.0.0/16"
    
    public_subnet_name      = "public"
    public_subnet           = "10.0.0.0/24"
    
    app_subnet_name         = "app"
    app_subnet              = "10.0.1.0/24"

    data_subnet_name        = "data"
    data_subnet             = "10.0.2.0/24"

    mgmt_subnet_name        = "mgmt"
    mgmt_subnet             = "10.0.3.0/24"

    gateway_subnet          = "10.0.255.0/24"

    enable_ptp_vpn          = 1
    ptp_vpn_remote_gw_name  = "New York Office 1"
    ptp_vpn_remote_endpoint = "12.13.14.15"
    ptp_vpn_remote_network  = "192.168.0.0/24"
}
</pre><br><br>