variable "peering_name" {
  type        = string
  description = "Name of the VPC peering connection"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the requester VPC"
}

variable "acceptor_vpc_id" {
  type        = string
  description = "The ID of the accepter VPC"
}

variable "acceptor_region_id" {
  type        = string
  description = "The region ID of the accepter VPC (leave empty or set to current region for intra-region peering)"
  default     = ""
}

variable "requester_route_table_ids" {
  type = list(string)
}

variable "acceptor_route_table_ids" {
  type = list(string)
}

variable "accepter_cidr_block" {
  type        = string
  description = "CIDR block of the accepter VPC (destination for requester route)"
}

variable "requester_cidr_block" {
  type        = string
  description = "CIDR block of the requester VPC (destination for accepter route)"
}

variable "acceptor_uid" {
  description = "need alicloud account if the vpcs in same account can be blank"
  type        = string
  default     = ""
}