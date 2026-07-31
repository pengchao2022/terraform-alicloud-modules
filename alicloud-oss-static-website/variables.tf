variable "bucket_name" {
  description = "The name of this bucket globally unique"
  type        = string
}

variable "storage_class" {
  description = "The type of OSS e.g., Standard, Archive..."
  type        = string
  default     = "Standard"
}

variable "index_document" {
  description = "The index name of this static website "
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document filename for static websites (commonly used for SPA single-page application redirects to index.html)"
  type        = string
  default     = "index.html"
}

# variable "domain_name" {
#   description = "The domain name of your website"
#   type        = string  
# }

variable "tags" {
  description = "The tags for the resources"
  type        = map(string)
  default     = {}
}