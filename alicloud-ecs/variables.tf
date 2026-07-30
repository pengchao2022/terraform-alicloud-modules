# 实例配置
variable "instance_configs" {
  description = "ECS 实例配置列表"
  type = list(object({
    instance_name   = string
    host_name       = optional(string, "")
    instance_type   = string
    vswitch_id      = string
    allocate_public_ip = optional(bool, false)
    internet_bandwidth = optional(number, 0)
  }))
}

# 共享配置
variable "image_id" {
  description = "Ubuntu 镜像 ID"
  type        = string
  default     = "ubuntu_22_04_x64_20G_alibase_20230613.vhd"
}

variable "security_group_ids" {
  description = "安全组 ID 列表"
  type        = list(string)
}

variable "public_key_content" {
  description = "SSH 公钥内容"
  type        = string
}

variable "system_disk_category" {
  description = "系统盘类型"
  type        = string
  default     = "cloud_essd"
}

variable "system_disk_size" {
  description = "系统盘大小 GB"
  type        = number
  default     = 40
}

variable "charge_type" {
  description = "计费类型"
  type        = string
  default     = "PostPaid"
}

variable "period" {
  description = "包年包月时长（月）"
  type        = number
  default     = 1
}

variable "tags" {
  description = "资源标签"
  type        = map(string)
  default     = {}
}