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

#### gcloud
```
gcloud auth login --no-launch-browser
```

```
gcloud config set account $SERVICE_ACCOUNT
```

```
gcloud config set project $PROJECT_NAME
```

#### create cluster
```
gcloud container clusters create $CLUSTER_NAME \
	--zone $ZONE \
	--machine-type $MACHINE_TYPE \
	--num-nodes 1
```

#### get credentials
```
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_NAME
```

#### create namespace, deployment and service
```
kubectl apply -f namespace.yaml
kubectl apply -f deploy.yaml
kubectl apply -f service.yaml
```


#### list addresses for LoadBalancer
```
gcloud compute addresses list $CLUSTER_NAME
```

#### delete address for LoadBalancer
```
gcloud compute addresses delete $CLUSTER_NAME --region $REGION
```

#### create address for LoadBalancer
```
gcloud compute addresses create $CLUSTER_NAME --region $REGION
```

#### get informations
```
kubectl -n $NAMESPACE get deployments -o wide
kubectl -n $NAMESPACE get nodes -o wide
kubectl -n $NAMESPACE get pods -o wide
kubectl -n $NAMESPACE get services -o wide
```

#### detailed informations
```
kubectl -n $NAMESPACE describe deployments
kubectl -n $NAMESPACE describe nodes
kubectl -n $NAMESPACE describe pods
kubectl -n $NAMESPACE describe services
```

#### ssh into pod
```
gcloud compute ssh --zone $ZONE <NODE> --project $PROJECT_NAME --container=<POD>
# gcloud compute ssh --zone $ZONE ngonzalez@gke-kibana-default-pool-9f50ce34-2q7g --project $PROJECT_NAME --container=67092bf47844
```

```
ssh -J <GCLOUD_USER>@<NODE_EXTERNAL_IP> <USER>@<POD_IP>
# ssh -J ngonzalez@35.228.245.113 debian@10.76.0.9
```

```
ssh -o ProxyCommand='ssh -W %h:%p <GCLOUD_USER>@<NODE_EXTERNAL_IP>' <USER>@<POD_IP>
```

#### update gcloud
```
gcloud components update
```
