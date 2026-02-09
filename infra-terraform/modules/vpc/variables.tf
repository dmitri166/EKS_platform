variable "name" {
  description = "Name prefix for the VPC and related resources"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to use (1 for lowest cost, up to 3)"
  type        = number
  default     = 1
}

variable "single_nat_gateway" {
  description = "If true, create a single NAT Gateway shared by all private subnets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}


