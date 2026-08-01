output "cluster_id" {
  value       = alicloud_cs_managed_kubernetes.default.id
  description = "ACK Cluster ID"
}

output "cluster_name" {
  value       = alicloud_cs_managed_kubernetes.default.name
  description = "ACK Cluster Name"
}

output "cluster_skube_config" {
  value       = alicloud_cs_managed_kubernetes.default.connections.api_server_internet
  description = "API Server Internet connection endpoint"
  sensitive   = true
}