#### build image
```
docker build . -t $IMAGE_TAG \
	--build-arg user=$USER \
	--build-arg host_key="$HOST_KEY" \
	--no-cache
```

#### push to google container registry
```
docker tag $IMAGE_TAG gcr.io/$PROJECT_NAME/$IMAGE_TAG
```

```
docker push gcr.io/$PROJECT_NAME/$IMAGE_TAG
```
