## Function

perform as alicloud OSS public access , OSS is like aws s3


## Usage

### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aliyun/alicloud | >= 1.200.0 |

### Providers

| Name | Version |
|------|---------|
| aliyun/alicloud | >= 1.200.0 |


### Deploy

download this module in your lcoal directory and call this module like this:

```shell

module "maxwell_pub_oss_bucket" {
  source = "./modules/alicloud-oss-public"

  bucket_name = "maxwell-public-bucket-05210"

  storage_class = "Standard"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

```

