# debian-stretch

![kisspng-docker-microservices-application-software-cloud-co-docker-logo-software-logo-5b706279caa081 27892087153409189783](https://user-images.githubusercontent.com/26479/113611336-aa143a80-964e-11eb-9ced-4d6ceca2fd7f.jpg)

#### build image
```
docker build . -t $IMAGE_TAG \
	--build-arg user=$USER \
	--build-arg host_key="$HOST_KEY" \
	--no-cache
```

#### create container
```
docker run -it -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	--cap-add SYS_ADMIN \
	$IMAGE_TAG:latest
```

#### access container shell
```
docker exec -it <CONTAINER> /bin/zsh
```

#### push to docker hub
```
docker push $IMAGE_TAG
```

#### push to google container registry
```
docker tag $IMAGE_TAG gcr.io/$PROJECT_NAME/$IMAGE_TAG
```

```
docker push gcr.io/$PROJECT_NAME/$IMAGE_TAG
```
