output "security_group_id" {
  description = "The ID of security group"
  value       = alicloud_security_group.this.id
}

output "security_group_name" {
  description = "The Name of security group"
  value       = alicloud_security_group.this.security_group_name
}