#!/bin/bash

REGION="${REGION:-europe-west9}"
BUCKET_NAME="${BUCKET_NAME:-steren-openclaw-bucket}"
# If you have access to GitHub container registry support for Cloud Run,
# you can use ghcr.io/openclaw/openclaw:latest
# otherwise, use alpine/openclaw:latest
IMAGE="alpine/openclaw:latest"

PROJECT_ID=$(gcloud config get-value project)

# Enable Vertex AI API
echo "Enabling Vertex AI API..."
gcloud services enable aiplatform.googleapis.com --project="$PROJECT_ID"

# Create the GCS bucket (ignoring errors if it already exists)
gcloud storage buckets create gs://$BUCKET_NAME --location="$REGION" || true

# Copy config
gcloud storage cp openclaw.json gs://$BUCKET_NAME/

# Create Service Account
SERVICE_ACCOUNT_NAME="openclaw-sa"
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
echo "Setting up Service Account ${SERVICE_ACCOUNT_EMAIL}..."
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME --display-name="OpenClaw Service Account" || true
gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" --role="roles/storage.objectAdmin"
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" --role="roles/aiplatform.user"

# Deploy
gcloud alpha run instances create clanker \
  --image "$IMAGE" \
  --service-account "$SERVICE_ACCOUNT_EMAIL" \
  --port 18789 \
  --cpu 4 \
  --memory 4Gi \
  --no-invoker-iam-check \
  --add-volume mount-path=/home/node/.openclaw,type=cloud-storage,mount-options="uid=1000;gid=1000;file-mode=0700;dir-mode=0700",bucket=$BUCKET_NAME \
  --set-secrets GEMINI_API_KEY=gemini-api-key:latest,OPENCLAW_GATEWAY_PASSWORD=openclaw-gateway-password:latest \
  --region "$REGION"
  
