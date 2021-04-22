# debian-stretch

![docker_facebook_share](https://user-images.githubusercontent.com/26479/113612228-d7151d00-964f-11eb-9d5c-66b8c07ca5cc.png)

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
export PROJECT_NAME='project'
```

```
docker tag $IMAGE_TAG gcr.io/$PROJECT_NAME/$IMAGE_NAME
```

```
docker push gcr.io/$PROJECT_NAME/$IMAGE_NAME
```
