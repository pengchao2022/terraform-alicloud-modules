## Function

perform as alicloud ecs instance creation, using this module you can create multiple ecs instances 


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

module "maxwell_ecs_dev" {
  source = "./modules/alicloud-ecs"

  instance_configs = [
    {
      instance_name   = "maxwell-public"
      host_name       = "public-server"
      instance_type   = "ecs.e-c1m1.large"
      vswitch_id      = module.maxwell_vpc.public_vswitch_ids[0]  
      allocate_public_ip = true
      internet_bandwidth = 10
    },
   
    {
      instance_name   = "maxwell-app-01"
      host_name       = "app-server-01"
      instance_type   = "ecs.e-c1m1.large"
      vswitch_id      = module.maxwell_vpc.private_vswitch_ids[0]  
      allocate_public_ip = false
      internet_bandwidth = 0
    },
  
    {
      instance_name   = "maxwell-app-02"
      host_name       = "app-server-02"
      instance_type   = "ecs.e-c1m1.large"
      vswitch_id      = module.maxwell_vpc.private_vswitch_ids[1]  
      allocate_public_ip = false
      internet_bandwidth = 0
    }
  ]

  security_group_ids = [
    module.security_group_ssh.security_group_id,
    module.security_group_icmp.security_group_id
  ]
  
  public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGItthHZvUum/HO2EKun7jkPUvDUkc6ZjQ0P6LfVRm8iyosphuOxBEA7pQUt3cldYnzyC5u5zwQ+zL8/2SmGZwfUsk3L0pGMSzWaA3fmGcCVj3vkH4BINQ1UWI7RPE04/UUAv/LLecwKS+q7lubugJKNpuyrt027U+1a5FcKcKurK/MrCLx9UaQ08cFYORrddx/qcfIwTPvsAjRNldaZpU+q+Nl0GCHDi+RJlm5ZlOfi7XQ0BznPpQezAVT4DcFU50hCzkDLTwo7/1kPkdO3OG5pysS75S5t2OnKPbZWGqdhjiUX6KdoXOMjaoZC6rwegChrgjrKvtfg5MPXT8FWbCkCBV/I/0D0/yTthe8bmHX9PyUG8VztfT5D795biCRZx06ZyRNfAUXCLCG//5AbTezMTxfCkNkC8O3xDKuy6A/Aj5jWMldlLbxpXoAddidiLttpeMV+ROTHNmHqoN/i65Mb8+Ovet1WgWX2HG0u5S2T0pSz9jZJNWf69GSMp/ZtQri4+KZ4dMdO+rUTxfnKa7oH4rblYVjAF0ENUNT9T+S6nXhmr3qV2gnXS/KTREYoi1InwZCA0cKiJq+sWRtO02tao662dW4BCYwOer8gojBMERY2aZ6d24yeyLVcI+9C4GYnqDz+zw1L2CdPi0EraP8xP9zpeux1J8pFV95pFWIw== pengchao.ma2@outlook.com"

  system_disk_category = "cloud_essd"
  system_disk_size     = 40

  charge_type = "PostPaid"
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

```

