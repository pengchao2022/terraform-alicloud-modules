resource "alicloud_vpc" "this" {
  vpc_name   = "${var.project_name}-vpc"
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = "${var.project_name}-vpc" })
}

resource "alicloud_vswitch" "public" {
  count        = 3
  vpc_id       = alicloud_vpc.this.id
  cidr_block   = var.public_subnet_cidrs[count.index]
  zone_id      = var.availability_zones[count.index]
  vswitch_name = "${var.project_name}-public-subnet-${count.index + 1}"
  tags         = merge(var.tags, { Name = "${var.project_name}-public-subnet-${count.index + 1}" })
}


resource "alicloud_vswitch" "private" {
  count        = 3
  vpc_id       = alicloud_vpc.this.id
  cidr_block   = var.private_subnet_cidrs[count.index]
  zone_id      = var.availability_zones[count.index]
  vswitch_name = "${var.project_name}-private-subnet-${count.index + 1}"
  tags         = merge(var.tags, { Name = "${var.project_name}-private-subnet-${count.index + 1}" })
}


resource "alicloud_eip" "this" {
  bandwidth            = 100
  internet_charge_type = "PayByTraffic"
  payment_type         = "PayAsYouGo"
  tags                 = merge(var.tags, { Name = "${var.project_name}-eip" })
}


resource "alicloud_nat_gateway" "this" {
  vpc_id           = alicloud_vpc.this.id
  nat_gateway_name = "${var.project_name}-nat"
  nat_type         = "Enhanced"
  vswitch_id       = alicloud_vswitch.public[0].id
  payment_type     = "PayAsYouGo"
  tags             = merge(var.tags, { Name = "${var.project_name}-nat" })
}

# attach EIP to NAT
resource "alicloud_eip_association" "this" {
  instance_id   = alicloud_nat_gateway.this.id
  allocation_id = alicloud_eip.this.id
}

# public route table
resource "alicloud_route_table" "public" {
  vpc_id           = alicloud_vpc.this.id
  route_table_name = "${var.project_name}-public-rt"
  description      = "Public route table for internet access"
  tags             = merge(var.tags, { Name = "${var.project_name}-public-rt" })
}

# public route
resource "alicloud_route_entry" "public_internet" {
  route_table_id         = alicloud_route_table.public.id
  destination_cidrblock  = "0.0.0.0/0"
  nexthop_type           = "NatGateway"
  nexthop_id             = alicloud_nat_gateway.this.id
  depends_on             = [alicloud_eip_association.this]
}

# attach public subnets to public route table
resource "alicloud_route_table_attachment" "public" {
  count          = 3
  route_table_id = alicloud_route_table.public.id
  vswitch_id     = alicloud_vswitch.public[count.index].id
  depends_on     = [alicloud_route_entry.public_internet]
}

# private route table
resource "alicloud_route_table" "private" {
  vpc_id           = alicloud_vpc.this.id
  route_table_name = "${var.project_name}-private-rt"
  description      = "Private route table for internal communication"
  tags             = merge(var.tags, { Name = "${var.project_name}-private-rt" })
}


resource "alicloud_route_table_attachment" "private" {
  count          = 3
  route_table_id = alicloud_route_table.private.id
  vswitch_id     = alicloud_vswitch.private[count.index].id
  depends_on     = [alicloud_route_table.private]
}