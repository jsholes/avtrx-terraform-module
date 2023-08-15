variable aws_region {
  description = "Region for spoke deployment"
  default     = "us-east-1"
}

variable spoke_vpc_id {
  description = "VPC ID of the target spoke VPC to connect to Aviatrix transit"
}

variable spoke_vpc_cidr {
  description = "VPC CIDR block"
}

variable create_aviatrix_account {
  description = "boolean specifies whether to add account in aviatrix, only do this once per account, not per VPC"
  default     = false
  type        = bool
}

variable gateway_name_prefix {
  description = "optional prefix for the newly created Aviatrix gateway instance names, defaults to account name"
  default     = ""
}

variable create_ha_gateway {
  description = "create a redundant gateway?"
  default     = true
  type        = bool
}

variable gateway_instance_size {
  description = "ec2 instance size for gateway(s), must meet Aviatrix support - c and t series only"
}

variable public_subnet_primary_cidr {
  description = "optional CIDR of public subnet to use/create for gateway, otherwise will be calculated"
  default     = ""
}

variable public_subnet_secondary_cidr {
  description = "optional CIDR of secondary public subnet to use/create for gateway, otherwise will be calculated"
  default     = ""
}

variable managed_route_tables_list {
  description = "List of rtb IDs that Aviatrix should manage within this VPC. Optional - if not provided Aviatrix manages all RTB"
  default     = []
  type        = list(string)
}

variable transit_gateway_name {
  description = "optional name of the primary Aviatrix gateway (HA gateway name will be derived)"
  default     = ""
  type        = string
}

variable account_name {
  description = "AWS account name of target spoke"
}

variable account_number {
  description = "AWS account number of target spoke"
}

variable network_account_number {
  description = "AWS account number of network account"
  default = ""
}

variable common_tags {
  description = "Additional tags for resources"
  type        = map
  default     = {
    BusinessOwner = "IS"
    ITOwner       = "Network"
    ManagedBy     = "aviatrix"
    RepoSource    = "Jasdev"
  }
}
