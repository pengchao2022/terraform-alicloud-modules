## Function

perform as alicloud security group icmp creation to allow ping 


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

module "maxwell_frontend_website" {
  source         = "./modules/alicloud-oss-static-website"
  bucket_name    = "maxwell-frontend-site-webpage-05210"
  storage_class  = "Standard"
  index_document = "index.html"
  error_document = "index.html" 

  tags = {
    Environment = "Dev"
    Owner       = "Maxwell"
  }
}

}

```

