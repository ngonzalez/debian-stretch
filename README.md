```
docker network create \
  --driver=bridge \
  --subnet=172.28.0.0/16 \
  --ip-range=172.28.5.0/24 \
  --gateway=172.28.5.254 \
  br0
```

```
docker build github.com/ngonzalez/debian-stretch --no-cache -t debian-stretch \
    --build-arg ssh_prv_key="$(cat ~/.ssh/debian-stretch/id_rsa)" \
    --build-arg ssh_pub_key="$(cat ~/.ssh/debian-stretch/id_rsa.pub)" \
    --build-arg ssh_pub_host="$(cat ~/.ssh/id_rsa.pub)"
```

```
docker run -it -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --cap-add SYS_ADMIN \
    --dns 192.168.1.1 \
    --hostname stretch.home \
    --ip 172.28.5.0 \
    --name docker-debian-stretch \
    --network br0 \
    -p 2201:22 \
    -p 0.0.0.0:8001:80 \
    -p 4000:4000 \
    -p 5044:5044 \
    debian-stretch:latest
```

```
docker exec -it <container_name> /bin/zsh
```

```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container_name>
```
