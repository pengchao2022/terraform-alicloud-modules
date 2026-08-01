## Function

perform as alicloud kubernetes creation, this ACK module depends on VPC module

when you plan to create ACK please plan for the network as following:

- VPC CIDR (physical network) and Pod CIDR(terway switch) can use the VPC module output value

- Service CIDR(cluster internal service using ) must be totally different network with VPC CIDR


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

# using nginx ingress controll add-on
module "maxwell_ack_prod" {
  source = "./modules/alicloud-ack"

  region_id       = "cn-hangzhou"
  cluster_name    = "maxwell-prod-nginx"
  k8s_version     = "1.35.2-aliyun.1"
  cluster_spec    = "ack.pro.small"

  vpc_id                    = module.maxwell_vpc_prod.vpc_id
  node_vswitch_ids          = module.maxwell_vpc_prod.private_vswitch_ids
  terway_vswitch_ids        = module.maxwell_vpc_prod.private_vswitch_ids
  service_cidr              = "172.19.0.0/20"
  worker_instance_types     = ["ecs.c6.xlarge"]
  default_node_desired_size = 2  
  autoscale_min_size        = 0  
  autoscale_max_size        = 0
  node_image_id = "ubuntu_22_04_x64_20G_alibase_20230613.vhd"



  cluster_addons = [
    {
      "name"   = "terway-eniip",
      "config" = "",
    },
    {
      "name"   = "loongcollector",
      "config" = "{\"IngressDashboardEnabled\":\"true\"}",
    },
    {
      "name"   = "nginx-ingress-controller",
      "config" = "{\"IngressSlbNetworkType\":\"internet\"}",
    },
    {
      "name"   = "arms-prometheus",
      "config" = "",
    },
    {
      "name"   = "ack-node-problem-detector",
      "config" = "{\"sls_project_name\":\"\"}",
    },
    {
      "name"   = "csi-plugin",
      "config" = "",
    },
    {
      "name"   = "csi-provisioner",
      "config" = "",
    }
  ]
  depends_on = [
    module.maxwell_vpc_prod
  ]
}

# ack using terway and alicloud alb
module "maxwell_ack_dev" {
  source = "./modules/alicloud-ack"

  region_id       = "cn-hangzhou"
  cluster_name    = "maxwell-dev-alb"
  k8s_version     = "1.36.1-aliyun.1"
  cluster_spec    = "ack.pro.small"

  vpc_id                    = module.maxwell_vpc_prod.vpc_id
  node_vswitch_ids          = module.maxwell_vpc_prod.private_vswitch_ids
  terway_vswitch_ids        = module.maxwell_vpc_prod.private_vswitch_ids
  service_cidr              = "172.19.0.0/20"
  worker_instance_types     = ["ecs.c6.xlarge"]
  default_node_desired_size = 2  
  autoscale_min_size        = 0  
  autoscale_max_size        = 0
  node_image_id = "ubuntu_22_04_x64_20G_alibase_20230613.vhd"
  

  cluster_addons = [
    {
      "name"   = "terway-eniip",
      "config" = "",
    },
    {
      "name"   = "loongcollector",
      "config" = "{\"IngressDashboardEnabled\":\"true\"}",
    },
    {
      "name"   = "alb-ingress-controller",
      "config" = "{}",
    },
    {
      "name"   = "arms-prometheus",
      "config" = "",
    },
    {
      "name"   = "ack-node-problem-detector",
      "config" = "{\"sls_project_name\":\"\"}",
    },
    {
      "name"   = "csi-plugin",
      "config" = "",
    },
    {
      "name"   = "csi-provisioner",
      "config" = "",
    }
  ]
  depends_on = [
    module.maxwell_vpc_prod
  ]
}



```

Useful command to connect ACK on your Mac terminal

- if you don't know the available or full version name for ack then query like this:
```shell
# check the ACK kubernetes VERSION
aliyun oos GetParameter --Name aliyun/services/cs/ManagedKubernetes/KubernetesVersion/1.35_latest

```

- connect to ACK
```shell
aliyun cs DescribeClusterUserKubeconfig --ClusterId c43b7095b36dd439ebc108aa5b1e833e7 | jq -r '.config' > ~/.kube/config

```
- add the second ACK cluster
```shell
aliyun cs DescribeClusterUserKubeconfig --ClusterId c43b7095b36dd439ebc108aa5b1e833e7 | jq -r '.config' > ~/.kube/config-dev-alb

```
- merge the two clusters config file
```shell
export KUBECONFIG=~/.kube/config:~/.kube/config-dev-alb
kubectl config view --flatten > ~/.kube/config-merged
mv ~/.kube/config-merged ~/.kube/config

```
- verify the ACK clusters
```shell
kubectl config get-contexts

```
- rename the ACK cluster display name
```shell
kubectl config rename-context 201176685312308451-c7eb807d231454506adb97b1fa0323b91 maxwell-ack-dev-alb

kubectl config rename-context 201176685312308451-c9982d4640b9e40cc8f78650dfa576fca maxwell-ack-prod-nginx

```
- check the changed names
```shell
kubectl config get-contexts 

```

- delete ACK cluster from config file
```shell
kubectl config delete-context 201176685312308451-c7eb807d231454506adb97b1fa0323b91

```

- add AWS EKS to config file
```shell
aws eks update-kubeconfig --region us-east-1 --name maxwell-eks-dev

```

- switch to another kubernetes cluster
```shell
kubectl config use-context arn:aws:eks:us-east-1:317429619308:cluster/maxwell-eks-dev

```



