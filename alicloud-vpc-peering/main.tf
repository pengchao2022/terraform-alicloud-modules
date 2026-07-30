resource "alicloud_vpc_peer_connection" "this" {
  peer_connection_name = var.peering_name
  vpc_id               = var.vpc_id
  accepting_vpc_id     = var.acceptor_vpc_id       
  accepting_region_id  = var.acceptor_region_id != "" ? var.acceptor_region_id : "cn-shanghai"
  accepting_ali_uid    = var.acceptor_uid != "" ? var.acceptor_uid : null
  description          = "VPC Peering created by Terraform"
}


resource "alicloud_route_entry" "requester_route" {
  count                 = length(var.requester_route_table_ids)
  route_table_id        = var.requester_route_table_ids[count.index]
  destination_cidrblock = var.accepter_cidr_block
  nexthop_type          = "VpcPeer"
  nexthop_id            = alicloud_vpc_peer_connection.this.id
}


resource "alicloud_route_entry" "acceptor_route" {
  count                 = length(var.acceptor_route_table_ids)
  route_table_id        = var.acceptor_route_table_ids[count.index]
  destination_cidrblock = var.requester_cidr_block
  nexthop_type          = "VpcPeer"
  nexthop_id            = alicloud_vpc_peer_connection.this.id
}