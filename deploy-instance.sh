#!/bin/bash

REGION="${REGION:-europe-west9}"
BUCKET_NAME="${BUCKET_NAME:-steren-openclaw-bucket}"

# Create the GCS bucket (ignoring errors if it already exists)
gcloud storage buckets create gs://$BUCKET_NAME --location="$REGION" || true

# Copy config
gcloud storage cp openclaw.json .env gs://$BUCKET_NAME/

# Deploy
gcloud alpha run instances create openclaw-instance \
  --image alpine/openclaw:latest \
  --port 18789 \
  --memory 4Gi \
  --ingress all \
  --no-invoker-iam-check \
  --add-volume mount-path=/home/node/.openclaw,type=cloud-storage,bucket=$BUCKET_NAME \
  --region "$REGION"
  
