variable "bucket_name" {
  description = "The name of bucket it must be global unique"
  type        = string  
}

variable "storage_class" {
  description = "The storage type e.g. Standard, IA, Archive, ColdArchive, DeepColdArchive"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "The tags for the resources"
  type        = map(string)
  default = {}
}