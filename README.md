# terraform-azure-network
Terraform module to build the network layer in Azure.  This is a more traditional layout ideal for orgs with a single team or orgs that don't isolate by networks.

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

    enable_ptp_vpn              = true
    virtual_network_gateway_sku = "VpnGw1"
    ptp_vpn_psk                 = "password"
    ptp_vpn_remote_gw_name      = "New-York-Office-1"
    ptp_vpn_remote_endpoint     = "12.13.14.15"
    ptp_vpn_remote_network      = "192.168.0.0/24"
    ptp_vpn_ike_encryption      = "AES256"
    ptp_vpn_ike_integrity       = "SHA256"
    ptp_vpn_dh_group            = "DHGroup2"
    ptp_vpn_ipsec_encryption    = "GCMAES256"
    ptp_vpn_ipsec_integrity     = "GCMAES256"
    ptp_vpn_pfs_group           = "PFS2"
    ptp_vpn_sa_lifetime         = "3600"
}
</pre><br><br>
