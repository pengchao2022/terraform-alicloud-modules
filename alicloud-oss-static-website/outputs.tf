output "bucket_name" {
  description = "The name of this bucket"
  value       = alicloud_oss_bucket.this.bucket
}

output "website_endpoint" {
  description = "Website public URL for this bucket to access"
  value       = "http://${alicloud_oss_bucket.this.bucket}.oss-website-${data.alicloud_regions.current.regions[0].id}.aliyuncs.com"
}

output "bucket_endpoint" {
  description = "Public URL of this bucket"
  value       = "https://${alicloud_oss_bucket.this.bucket}.oss-${data.alicloud_regions.current.regions[0].id}.aliyuncs.com"
}