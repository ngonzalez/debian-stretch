
```bash
docker build github.com/ngonzalez/debian-stretch -t debian
```

```bash
docker run -it -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
               --cap-add SYS_ADMIN \
               debian:latest
```

