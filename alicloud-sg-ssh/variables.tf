variable "security_group_name" {
  description = "The Name for security group"
  type        = string
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "Security group for SSH access"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allow_ssh_cidrs" {
  description = "The CIDR blocks which allowed ssh"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "The resource tags"
  type        = map(string)
  default     = {}
}