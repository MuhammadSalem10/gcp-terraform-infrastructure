#!/bin/bash

PROJECT_ID="extra-project-460210"
REGION="us-central1"
REPOSITORY="dev-docker-images"
IMAGE_NAME="demo-app"
TAG="latest"

echo "Cloning repository..."
git clone https://github.com/ahmedzak7/GCP-2025.git
cd GCP-2025/DevOps-Challenge-Demo-Code-master

echo "Authenticating Docker with Artifact Registry..."
gcloud auth configure-docker ${REGION}-docker.pkg.dev

echo "Building Docker image..."
docker build -t ${IMAGE_NAME} .

echo "Tagging image for Artifact Registry..."
docker tag ${IMAGE_NAME} ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY}/${IMAGE_NAME}:${TAG}

echo "Pushing image to Artifact Registry..."
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY}/${IMAGE_NAME}:${TAG}

echo "Image successfully pushed to Artifact Registry!"
