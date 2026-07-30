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

output "route_table_ids" {
  description = "List of custom route table IDs created in the VPC"
  value       = [
    alicloud_route_table.public.id,
    alicloud_route_table.private.id
  ]
}