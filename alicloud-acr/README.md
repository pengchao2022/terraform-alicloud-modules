## Function

perform as build docker image and push to alicloud acr 


## Usage

- login to alicloud acr
```shell
docker login --username=maxwell@1921592033864229 registry.cn-hangzhou.aliyuncs.com
```
- type your password

- docker buld and push to acr

   - maxwell-mage-0521 is the namespace

   - web-frontend is the registry name

```shell
llen@192 web-fronted % docker buildx build \
  --platform linux/amd64 \
  -t registry.cn-hangzhou.aliyuncs.com/maxwell-mage-0521/web-frontend:v1.0.0 \
  --push \
  .

```
You can also make a test on your local Mac

- pull down to loacl Mac
```shell

docker pull --platform linux/amd64 registry.cn-hangzhou.aliyuncs.com/maxwell-mage-0521/web-frontend:v2.0.0

```

-  run on Mac
```shell

docker run -d -p 8080:80 registry.cn-hangzhou.aliyuncs.com/maxwell-mage-0521/web-frontend:v2.0.0

```

- Open browser to check the webpage

```shell

http://localhost:8080

```

