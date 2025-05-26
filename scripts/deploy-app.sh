#!/bin/bash

CLUSTER_NAME="dev-private-gke-cluster"
REGION="us-central1"

echo "Getting GKE credentials..."
gcloud container clusters get-credentials ${CLUSTER_NAME} --region=${REGION}

echo "Deploying application to GKE..."
kubectl apply -f manifests/demo-app.yaml

echo "Checking deployment status..."
kubectl get deployments
kubectl get services
kubectl get pods

echo "Application deployed successfully!"
