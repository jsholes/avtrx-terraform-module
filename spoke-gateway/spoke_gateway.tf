locals {
  gateway_name_prefix = var.gateway_name_prefix != "" ? var.gateway_name_prefix : var.account_name

  cidr_length = element(split("/", var.spoke_vpc_cidr), 1)
  public_subnet_primary_cidr = cidrsubnet(var.spoke_vpc_cidr, 28 - local.cidr_length, pow(2, (28 - local.cidr_length)) - 16)
  public_subnet_secondary_cidr = cidrsubnet(var.spoke_vpc_cidr, 28 - local.cidr_length, pow(2, (28 - local.cidr_length)) - 15)
  
  ha_subnet_derived = var.public_subnet_secondary_cidr != "" ? var.public_subnet_secondary_cidr : local.public_subnet_secondary_cidr
}

resource "aviatrix_spoke_gateway" "spoke_gateway_1" {
    single_az_ha = true
    gw_name = var.aws_spoke_name
    vpc_id = var.spoke_vpc_id
    cloud_type = 1
    vpc_reg = var.aws_region
    gw_size = var.gateway_instance_size
    account_name = var.account_name
    subnet = var.public_subnet_primary_cidr != "" ? var.public_subnet_primary_cidr : local.public_subnet_primary_cidr
    enable_encrypt_volume = true
    
    // Doing this manually allows us to properly specify dependencies so destroy
    // operations don't get 'stuck'
    manage_transit_gateway_attachment = false
    
    // Watch for instances spun up in the Aviatrix subnets and shut them down if found
    // Requires Aviatrix TF provider >= 2.18.0
    enable_monitor_gateway_subnets = true
    
    // HA settings
    ha_subnet = var.create_ha_gateway ? local.ha_subnet_derived : null
    ha_gw_size = var.create_ha_gateway ? var.gateway_instance_size : null
    
    tags = merge(
      { Application = "Aviatrix Cloud Network" },
      { Replication = "no"},
      { TimeFlag    = "24x7"},
      var.common_tags
    )    
      
}

# resource "aviatrix_spoke_transit_attachment" "spoke_attach_1" {
#     spoke_gw_name   = aviatrix_spoke_gateway.spoke_gateway_1.gw_name
#     transit_gw_name = var.transit_gateway_name != "" ? var.transit_gateway_name : "transit-${var.aws_region}"
#     route_tables    = var.managed_route_tables_list
# }

