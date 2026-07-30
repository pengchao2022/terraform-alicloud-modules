output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.this.id
}

output "security_group_name" {
  description = "The Name of the security group"
  value       = alicloud_security_group.this.security_group_name
}