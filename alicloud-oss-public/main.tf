data "alicloud_regions" "current" {
  current = true
}

resource "alicloud_oss_bucket" "this" {
  bucket        = var.bucket_name
  storage_class = var.storage_class
  tags          = var.tags
}

resource "alicloud_oss_bucket_public_access_block" "this" {
  bucket              = alicloud_oss_bucket.this.bucket
  block_public_access = false  
}

resource "alicloud_oss_bucket_acl" "this" {
  bucket = alicloud_oss_bucket.this.bucket
  acl    = "public-read"

  depends_on = [alicloud_oss_bucket_public_access_block.this]
}

resource "alicloud_oss_bucket_versioning" "this" {
  bucket = alicloud_oss_bucket.this.bucket
  status = "Enabled"  
}