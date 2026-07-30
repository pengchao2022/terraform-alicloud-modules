## Function

perform as alicloud vpc peering and make two vpcs can communicate with each other



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

module "vpc_peering_dev_prod" {
  source = "./modules/alicloud-vpc-peering"

  peering_name = "dev-to-prod-peering"
  vpc_id = module.maxwell_vpc_dev.vpc_id             # requester vpc id
  acceptor_vpc_id = module.maxwell_vpc_prod.vpc_id   # accepter vpc id
  acceptor_region_id = "cn-hangzhou"

  requester_route_table_ids = module.maxwell_vpc_dev.route_table_ids
  acceptor_route_table_ids = module.maxwell_vpc_prod.route_table_ids

  requester_cidr_block = "172.16.0.0/16"
  accepter_cidr_block  = "10.0.0.0/16"

  acceptor_uid  = "1921592033864229"

}



```

