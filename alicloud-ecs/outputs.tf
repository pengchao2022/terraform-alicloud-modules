output "instance_ids" {
  description = "List of all ECS instance IDs"
  value       = alicloud_instance.this[*].id
}

output "instance_names" {
  description = "List of all ECS instance names"
  value       = alicloud_instance.this[*].instance_name
}

output "public_ips" {
  description = "List of all instance public IPs, or blank if none"
  value       = alicloud_instance.this[*].public_ip
}

output "private_ips" {
  description = "List of all instance private IPs"
  value       = alicloud_instance.this[*].private_ip
}

# Dynamically filter instance IDs that have a public IP (safe, does not rely on fixed indices)
output "public_instance_ids" {
  description = "List of instance IDs with public IPs"
  value       = [for inst in alicloud_instance.this : inst.id if inst.public_ip != ""]
}

# Dynamically filter private-only instance IDs (without public IPs)
output "private_only_instance_ids" {
  description = "List of private instance IDs with only internal IPs"
  value       = [for inst in alicloud_instance.this : inst.id if inst.public_ip == ""]
}