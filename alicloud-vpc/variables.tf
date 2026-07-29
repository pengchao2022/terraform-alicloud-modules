variable "project_name" {
  type        = string
  description = "Project name used as a prefix for naming resources"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public vSwitches"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private vSwitches"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones to distribute subnets"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}