```
docker build github.com/ngonzalez/debian-stretch -t debian \
   --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" \
   --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"
```

```
docker run -it -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
               --cap-add SYS_ADMIN \
               -p 22:22 \
               -p 80:80 \
               debian:latest
```

```
docker exec -it <container_name> /bin/bash
```

```
docker inspect -f "{{ .NetworkSettings.IPAddress }}" <container_name>
```

```
docker system prune -a
```