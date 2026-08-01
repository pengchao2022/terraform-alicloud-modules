resource "alicloud_vpc" "this" {
  vpc_name   = "${var.project_name}-vpc"
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = "${var.project_name}-vpc" })
}

resource "alicloud_vswitch" "public" {
  count        = length(var.public_subnet_cidrs)
  vpc_id       = alicloud_vpc.this.id
  cidr_block   = var.public_subnet_cidrs[count.index]
  zone_id      = var.availability_zones[count.index]
  vswitch_name = "${var.project_name}-public-subnet-${count.index + 1}"
  tags         = merge(var.tags, { Name = "${var.project_name}-public-subnet-${count.index + 1}" })
}

resource "alicloud_vswitch" "private" {
  count        = length(var.private_subnet_cidrs)
  vpc_id       = alicloud_vpc.this.id
  cidr_block   = var.private_subnet_cidrs[count.index]
  zone_id      = var.availability_zones[count.index]
  vswitch_name = "${var.project_name}-private-subnet-${count.index + 1}"
  tags         = merge(var.tags, { Name = "${var.project_name}-private-subnet-${count.index + 1}" })
}

# create eip for nat
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

resource "alicloud_eip_association" "this" {
  instance_id   = alicloud_nat_gateway.this.id
  allocation_id = alicloud_eip.this.id
}

resource "alicloud_route_table" "public" {
  vpc_id           = alicloud_vpc.this.id
  route_table_name = "${var.project_name}-public-rt"
  description      = "Public route table for internet access"
  tags             = merge(var.tags, { Name = "${var.project_name}-public-rt" })
}

resource "alicloud_route_entry" "public_internet" {
  route_table_id        = alicloud_route_table.public.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.this.id
  depends_on            = [alicloud_eip_association.this]
}

resource "alicloud_route_table_attachment" "public" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = alicloud_route_table.public.id
  vswitch_id     = alicloud_vswitch.public[count.index].id
  depends_on     = [alicloud_route_entry.public_internet]
}

resource "alicloud_route_table" "private" {
  vpc_id           = alicloud_vpc.this.id
  route_table_name = "${var.project_name}-private-rt"
  description      = "Private route table for internal communication"
  tags             = merge(var.tags, { Name = "${var.project_name}-private-rt" })
}

# add default route 0.0.0.0/0 to NAT
resource "alicloud_route_entry" "private_internet" {
  route_table_id        = alicloud_route_table.private.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.this.id
  depends_on            = [alicloud_eip_association.this]
}


resource "alicloud_route_table_attachment" "private" {
  count          = length(var.private_subnet_cidrs)
  route_table_id = alicloud_route_table.private.id
  vswitch_id     = alicloud_vswitch.private[count.index].id
  depends_on     = [alicloud_route_entry.private_internet]
}

# config snat 
resource "alicloud_snat_entry" "private_snat" {
  count             = length(var.private_subnet_cidrs)
  snat_table_id     = alicloud_nat_gateway.this.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private[count.index].id
  snat_ip           = alicloud_eip.this.ip_address
  depends_on        = [alicloud_eip_association.this]
}


# sls config , sls is like aws cloudwatch logs
resource "alicloud_log_project" "this" {
  count        = var.enable_cloudmonitor ? 1 : 0
  project_name = "${var.project_name}-log-project"
  description  = "Log project for ${var.project_name}"
  tags         = var.tags
}

resource "alicloud_log_store" "this" {
  count                 = var.enable_cloudmonitor ? 1 : 0
  logstore_name         = "${var.project_name}-log-store"
  project_name          = alicloud_log_project.this[0].project_name
  retention_period      = 30
  shard_count           = 2
  auto_split            = true
  max_split_shard_count = 10
}


# create contact group
resource "alicloud_cms_alarm_contact_group" "this" {
  count                    = var.enable_cloudmonitor ? 1 : 0
  alarm_contact_group_name = "${var.project_name}-alarm-group"
}

# nat outbound alarm
resource "alicloud_cms_alarm" "nat_outbound_bandwidth" {
  count = var.enable_cloudmonitor ? 1 : 0

  name              = "${var.project_name}-nat-outbound-bandwidth-alarm"
  metric            = "BWRateOutToOutside"
  project           = "acs_nat_gateway"
  metric_dimensions = jsonencode([{ instanceId = alicloud_nat_gateway.this.id }])

  period             = 300
  enabled            = true
  silence_time       = 86400
  effective_interval = "00:00-23:59"
  contact_groups     = [alicloud_cms_alarm_contact_group.this[0].alarm_contact_group_name]

  escalations_critical {
    statistics          = "Value"
    comparison_operator = ">="
    threshold           = 80000000 # 80 Mbps
    times               = 3
  }
}

# nat inbound alarm
resource "alicloud_cms_alarm" "nat_inbound_bandwidth" {
  count = var.enable_cloudmonitor ? 1 : 0

  name              = "${var.project_name}-nat-inbound-bandwidth-alarm"
  metric            = "BWRateInFromOutside"
  project           = "acs_nat_gateway"
  metric_dimensions = jsonencode([{ instanceId = alicloud_nat_gateway.this.id }])

  period             = 300
  enabled            = true
  silence_time       = 86400
  effective_interval = "00:00-23:59"
  contact_groups     = [alicloud_cms_alarm_contact_group.this[0].alarm_contact_group_name]

  escalations_critical {
    statistics          = "Value"
    comparison_operator = ">="
    threshold           = 80000000 # 80 Mbps
    times               = 3
  }
}


# create ram role for flow log
resource "alicloud_ram_role" "flow_log_role" {
  count       = var.enable_cloudmonitor ? 1 : 0
  role_name   = "${var.project_name}-flow-log-role"
  assume_role_policy_document = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "vpc.aliyuncs.com"
        ]
      }
    }
  ],
  "Version": "1"
}
EOF
  description = "Role for VPC Flow Log to write logs to SLS"
  force       = true
}

# give role the priviliege to write to sls , sls is like aws cloudwatch logs
resource "alicloud_ram_policy" "flow_log_policy" {
  count       = var.enable_cloudmonitor ? 1 : 0
  policy_name = "${var.project_name}-flow-log-policy"
  policy_document = jsonencode({
    Version = "1"
    Statement = [
      {
        Action = [
          "log:PostLogStoreLogs",
          "log:CreateLogStore",
          "log:GetLogStore"
        ]
        Effect   = "Allow"
        Resource = [
          "acs:log:*:*:project/${alicloud_log_project.this[0].project_name}",
          "acs:log:*:*:project/${alicloud_log_project.this[0].project_name}/logstore/${alicloud_log_store.this[0].logstore_name}"
        ]
      }
    ]
  })
  description = "Custom policy for VPC Flow Log to write to SLS"
}

# attach policy to role
resource "alicloud_ram_role_policy_attachment" "flow_log_attachment" {
  count       = var.enable_cloudmonitor ? 1 : 0
  role_name   = alicloud_ram_role.flow_log_role[0].role_name
  policy_name = alicloud_ram_policy.flow_log_policy[0].policy_name
  policy_type = "Custom"
}

# wait for role valide
resource "time_sleep" "wait_for_role" {
  count = var.enable_cloudmonitor ? 1 : 0
  
  depends_on = [
    alicloud_ram_role_policy_attachment.flow_log_attachment
  ]
  
  create_duration = "10s"
}

# create vpc flow log 
resource "alicloud_vpc_flow_log" "this" {
  count             = var.enable_cloudmonitor ? 1 : 0
  
  resource_type     = "VPC"
  resource_id       = alicloud_vpc.this.id
  traffic_type      = "Drop"  # reject network traffic
  project_name      = alicloud_log_project.this[0].project_name
  log_store_name    = alicloud_log_store.this[0].logstore_name
  flow_log_name     = "${var.project_name}-flow-log"
  description       = "Flow log capturing only rejected traffic for VPC"
  
  depends_on = [
    time_sleep.wait_for_role[0]
  ]
}