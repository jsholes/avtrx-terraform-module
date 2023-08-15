terraform {
  required_providers {
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
  }
  required_version = ">= 1.0"
}
