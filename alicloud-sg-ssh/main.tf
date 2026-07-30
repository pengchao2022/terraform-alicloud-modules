resource "alicloud_security_group" "this" {
  security_group_name = var.security_group_name
  description         = var.description
  vpc_id              = var.vpc_id
  tags                = var.tags
}

# ssh ingress rule 
resource "alicloud_security_group_rule" "ssh" {
  security_group_id = alicloud_security_group.this.id
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  cidr_ip           = var.allow_ssh_cidrs
  description       = "Allow SSH access"
}