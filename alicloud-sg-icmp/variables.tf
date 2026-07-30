variable "security_group_name" {
  description = "The name of security group"
  type        = string
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "Security group for ICMP (Ping) access"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allow_icmp_cidrs" {
  description = "The cidr blocks which allow icmp protocol"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "The resource tags"
  type        = map(string)
  default     = {}
}