output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.this.id
}

output "public_vswitch_ids" {
  description = "List of IDs of the public vSwitches"
  value       = alicloud_vswitch.public[*].id
}

output "private_vswitch_ids" {
  description = "List of IDs of the private vSwitches"
  value       = alicloud_vswitch.private[*].id
}