resource "alicloud_security_group" "this" {
  security_group_name = var.security_group_name
  description         = var.description
  vpc_id              = var.vpc_id
  tags                = var.tags
}

# icmp ingress rule
resource "alicloud_security_group_rule" "icmp" {
  security_group_id = alicloud_security_group.this.id
  type              = "ingress"
  ip_protocol       = "icmp"
  port_range        = "-1/-1"           
  cidr_ip           = var.allow_icmp_cidrs
  description       = "Allow ICMP (Ping)"
}