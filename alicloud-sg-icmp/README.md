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


module "security_group_icmp" {
  source = "./modules/alicloud-sg-icmp"

  security_group_name = "maxwell-sg-icmp"
  description         = "Allow ICMP Ping"
  vpc_id              = module.maxwell_vpc.vpc_id
  allow_icmp_cidrs    = "0.0.0.0/0"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
  
}

```

