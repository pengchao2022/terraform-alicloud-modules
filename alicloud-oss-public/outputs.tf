output "bucket_name" {
  description = "The name of OSS bucket"
  value       = alicloud_oss_bucket.this.bucket
}

output "bucket_endpoint" {
  description = "The public URL of this bucket to access"
  value       = "https://${alicloud_oss_bucket.this.bucket}.oss-${data.alicloud_regions.current.regions[0].id}.aliyuncs.com"
}

output "bucket_endpoint_internal" {
  description = "The internal URL of this bucket to access"
  value       = "${alicloud_oss_bucket.this.bucket}.oss-${data.alicloud_regions.current.regions[0].id}-internal.aliyuncs.com"
}