## Function

perform as alicloud security group ssh creation to allow a remote login


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


module "security_group_ssh" {
  source = "./modules/alicloud-sg-ssh"

  security_group_name = "maxwell-ecs-ssh-sg"

  description = "Security group for maxwell ecs"

  vpc_id      = module.maxwell_vpc.vpc_id

  allow_ssh_cidrs = "0.0.0.0/0"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
  
}

```

