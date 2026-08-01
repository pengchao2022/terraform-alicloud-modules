variable "region_id" {
  description = "The region of Alicloud ACK deployed"
  type        = string
  default = "cn-hangzhou"
}



variable "cluster_spec" {
  description = "The cluster specification of kubernetes cluster, Valid values: ack.standard, ack.pro.small."
  type        = string
  default     = "ack.pro.small" 
}

variable "availability_zone" {
  description = "The availability zones of vswitches"
  type        = list(string)
  default     = ["cn-hangzhou-h", "cn-hangzhou-j", "cn-hangzhou-i"]
}

variable "vpc_id" {
  description = "The ID of VPC for kubernetes to deploy"
  type        = string
  default     = ""
}

variable "node_vswitch_ids" {
  description = "List of existing node vswitch ids"
  type        = list(string)
  default     = []
}

variable "terway_vswitch_ids" {
  description = "List of existing pod vswitch ids for terway"
  type        = list(string)
  default     = []
}

variable "worker_instance_types" {
  description = "The ECS instance types to launch worker nodes"
  type        = list(string)
  default = [ "ecs.g6.2xlarge", "ecs.g6.xlarge" ]
}


variable "node_image_id" {
  type        = string
  description = "The image ID for the ACK node pools to support cgroup v2."
  default     = "" 
}

variable "default_node_desired_size" {
  description = "The initial node numbers"
  type        = number
  default     = 2
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "The customized name of the ACK cluster. If left empty, k8s_name_prefix will be used as the cluster name."
}

variable "autoscale_min_size" {
  description = "The min node numbers of acutoscale group"
  type        = number
  default     = 0
}

variable "autoscale_max_size" {
   description = "The max node numbers of autoscale group"
  type        = number
  default     = 0
 
}

variable "cluster_addons" {
  description = "The Core add-ons for kubernetes"
  type        = list(object({
    name   = string
    config = string
  }))
  default = [ 
    {
      "name"    = "terway-eniip",
      "config"  = "",
    },
    {
      "name"    = "loongcollector",
      "config" = "{\"IngressDashboardEnabled\":\"true\"}",
    },
    {
      "name"   = "nginx-ingress-controller",
      "config" = "{\"IngressSlbNetworkType\":\"internet\"}",
    },
    {
      "name"   = "arms-prometheus",
      "config" = "",
    },
    {
      "name"   = "ack-node-problem-detector",
      "config" = "{\"sls_project_name\":\"\"}",
    },
    {
      "name"   = "csi-plugin",
      "config" = "",
    },
    {
      "name"   = "csi-provisioner",
      "config" = "",
    } 
  ]
}
