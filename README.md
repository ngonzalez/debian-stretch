#### build image
```
docker build github.com/ngonzalez/debian-stretch --no-cache -t ngonzalez121/debian-stretch \
    --build-arg ssh_pub_host="$(cat ~/.ssh/id_rsa.pub)"
```

#### create container
```
docker run -it -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --cap-add SYS_ADMIN \
    debian-stretch:latest
```

#### access container shell
```
docker exec -it <container_name> /bin/zsh
```

#### get container IP address
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container_name>
```
