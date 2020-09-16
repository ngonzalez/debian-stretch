
```
docker build github.com/ngonzalez/debian-stretch -t debian
```

```
docker run -it -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
               --cap-add SYS_ADMIN \
               debian:latest
```

```
docker exec -it <container_name> /bin/bash
```