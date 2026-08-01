# create customer security group to ensure pods can go to internet
resource "alicloud_security_group" "cluster_sg" {
  security_group_name = "${var.cluster_name}-custom-sg"
  description         = "Custom security group for ACK cluster nodes to access internet"
  vpc_id              = var.vpc_id
}

resource "alicloud_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  security_group_id = alicloud_security_group.cluster_sg.id
  priority          = 1
  cidr_ip           = "0.0.0.0/0"
}


data "alicloud_ram_roles" "existing_autoscaler" {
  name_regex = "^aliyuncsmanagedautoscalerrole$"
}

# enable ack service
data "alicloud_ack_service" "open" {
  enable = "On"
  type   = "propayasgo"
}

resource "alicloud_cs_managed_kubernetes" "default" {
  depends_on = [data.alicloud_ack_service.open]

  name                         = var.cluster_name
  version                      = var.k8s_version
  cluster_spec                 = var.cluster_spec
  vswitch_ids                  = var.node_vswitch_ids
  pod_vswitch_ids              = var.terway_vswitch_ids
  new_nat_gateway              = false
  service_cidr                 = var.service_cidr
  slb_internet_enabled         = true
  enable_rrsa                  = true
  
  security_group_id            = alicloud_security_group.cluster_sg.id

  control_plane_log_components = ["apiserver", "kcm", "scheduler", "ccm"]

  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", "")
      config = lookup(addons.value, "config", "")
    }
  }
}


resource "alicloud_cs_kubernetes_node_pool" "default" {
  cluster_id            = alicloud_cs_managed_kubernetes.default.id
  node_pool_name        = "default-nodepool"
  vswitch_ids           = var.node_vswitch_ids
  instance_types        = var.worker_instance_types
  instance_charge_type  = "PostPaid"
  desired_size          = var.default_node_desired_size
  install_cloud_monitor = true
  system_disk_category  = "cloud_efficiency"
  system_disk_size      = 100
  image_type            = "AliyunLinux3"
  
  image_id              = var.node_image_id != "" ? var.node_image_id : null

  data_disks {
    category = "cloud_essd"
    size     = 120
  }
}

resource "alicloud_cs_kubernetes_node_pool" "managed_node_pool" {
  cluster_id     = alicloud_cs_managed_kubernetes.default.id
  node_pool_name = "managed-node-pool"
  vswitch_ids    = var.node_vswitch_ids
  desired_size   = 0
  management {
    auto_repair     = true
    auto_upgrade    = true
    max_unavailable = 1
  }
  instance_types        = var.worker_instance_types
  instance_charge_type  = "PostPaid"
  install_cloud_monitor = true
  system_disk_category  = "cloud_efficiency"
  system_disk_size      = 100
  image_type            = "AliyunLinux3"
  
  image_id              = var.node_image_id != "" ? var.node_image_id : null

  data_disks {
    category = "cloud_essd"
    size     = 120
  }
}

resource "alicloud_cs_kubernetes_node_pool" "autoscale_node_pool" {
  cluster_id     = alicloud_cs_managed_kubernetes.default.id
  node_pool_name = "autoscale-node-pool"
  vswitch_ids    = var.node_vswitch_ids
  scaling_config {
    min_size = var.autoscale_min_size
    max_size = var.autoscale_max_size
  }
  instance_types        = var.worker_instance_types
  install_cloud_monitor = true
  system_disk_category  = "cloud_efficiency"
  system_disk_size      = 100
  image_type            = "AliyunLinux3"
  
  image_id              = var.node_image_id != "" ? var.node_image_id : null
  
  ram_role_name         = data.alicloud_ram_roles.existing_autoscaler.roles[0].name

  data_disks {
    category = "cloud_essd"
    size     = 120
  }
}

