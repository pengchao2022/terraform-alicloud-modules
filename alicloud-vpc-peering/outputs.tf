output "peering_connection_id" {
  description = "The ID of the VPC peering connection"
  value       = alicloud_vpc_peer_connection.this.id
}

output "status" {
  description = "The status of the VPC peering connection"
  value       = alicloud_vpc_peer_connection.this.status
}