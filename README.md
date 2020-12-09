# terraform-azure-network
Terraform module to build network layer in Azure.  This module is intended to be used in Terraform Cloud and stored in a private registry.

## Example module
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
</pre>
