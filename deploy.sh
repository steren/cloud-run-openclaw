#!/bin/bash

REGION="${REGION:-europe-west9}"

# Create the GCS bucket (ignoring errors if it already exists)
gcloud storage buckets create gs://steren-openclaw-bucket --location="$REGION" || true

# Copy openclaw.json to the root of the bucket
gcloud storage cp openclaw.json gs://steren-openclaw-bucket/

gcloud run services replace service.yaml --region "$REGION"
