export NAMESPACE='hebe'
export PROJECT_NAME='hebe-299715'
export SERVICE_ACCOUNT='service-account@hebe-299715.iam.gserviceaccount.com'
export KEY_FILE="$HOME/.hebe-299715-fed8d8f694a1.json"
export IMAGE_TAG='debian-stretch'
export USER='debian'
export HOST_KEY=$(cat ~/.ssh/id_rsa.pub)
export REGION='europe-north1' # gcloud compute regions list
export ZONE='europe-north1-c' # gcloud compute zones list
export MACHINE_TYPE='n1-standard-8' # gcloud compute machine-types list --zones=$ZONE
export CLUSTER_NAME='kibana'
