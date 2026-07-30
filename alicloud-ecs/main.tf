# create ssh key pair
resource "alicloud_key_pair" "this" {
  key_pair_name   = "${var.instance_configs[0].instance_name}-keypair"
  public_key      = var.public_key_content
}

# allow to create multiple instance
resource "alicloud_instance" "this" {
  count = length(var.instance_configs)
  
  instance_name = var.instance_configs[count.index].instance_name
  host_name     = var.instance_configs[count.index].host_name != "" ? var.instance_configs[count.index].host_name : var.instance_configs[count.index].instance_name
  instance_type = var.instance_configs[count.index].instance_type
  
  image_id = var.image_id
  
  # vswitch is something like aws subnet ids
  vswitch_id      = var.instance_configs[count.index].vswitch_id 
  security_groups = var.security_group_ids
  
  system_disk_category = var.system_disk_category
  system_disk_size     = var.system_disk_size
  
  # pulic IP the alicloud use bandwidth > 0 to allowcate public IP
  internet_charge_type       = "PayByTraffic"
  internet_max_bandwidth_out = var.instance_configs[count.index].allocate_public_ip ? var.instance_configs[count.index].internet_bandwidth : 0
  
  # key name
  key_name = alicloud_key_pair.this.key_pair_name

  image_options {
    login_as_non_root = true
  }
  
  # pay method 
  instance_charge_type = var.charge_type
  period               = var.charge_type == "PrePaid" ? var.period : null
  
  tags = merge(var.tags, {
    Name = var.instance_configs[count.index].instance_name
  })
}