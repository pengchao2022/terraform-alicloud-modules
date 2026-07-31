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


resource "alicloud_oss_bucket_website" "this" {
  bucket = alicloud_oss_bucket.this.bucket

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
    http_status = "404"
  }

  depends_on = [alicloud_oss_bucket_acl.this]
}

# upload local index.html to oss
resource "alicloud_oss_bucket_object" "index_page" {
  bucket       = alicloud_oss_bucket.this.bucket 
  key          = "index.html"                    
  source       = "${path.module}/index.html"     
  content_type = "text/html"                    
  acl          = "public-read"

  depends_on = [alicloud_oss_bucket_acl.this]
}

# bind custom domain name if you have
# resource "alicloud_oss_bucket_cname" "domain" {
#   bucket      = alicloud_oss_bucket.this.bucket
#   domain      = var.domain_name

# 
#   depends_on = [alicloud_oss_bucket_website.this]
# }