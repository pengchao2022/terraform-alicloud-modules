## Function

perform as alicloud vpc creation, for example:

- create VPC
- create public subnets
- create private subnets
- create nat gateway
- create route tables
...

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

module "maxwell_vpc" {
  source = "./modules/alicloud-vpc"

  project_name = "maxwell-vpc"
  vpc_cidr     = "10.0.0.0/16"

  availability_zones    = ["cn-hangzhou-i", "cn-hangzhou-j"]

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}


```

