# cloud-run-openclaw
Deploy OpenClaw effortlessly on Google Cloud Run using standard Knative YAML configurations.

## Prerequisites

1. Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (`gcloud`) if you haven't already.
2. Authenticate with Google Cloud and set your project:
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```
3. Enable the Vertex AI API in your Google Cloud Project:
   ```bash
   gcloud services enable aiplatform.googleapis.com
   ```
4. Create the required secrets for the Gemini API key and gateway password in Google Cloud Secret Manager:
   ```bash
   echo -n "your_actual_api_key" | gcloud secrets create gemini-api-key --data-file=-
   echo -n "your_secure_password" | gcloud secrets create openclaw-gateway-password --data-file=-
   ```
   Note: Authentication for the Vertex AI model is handled automatically using the Cloud Run instance's Service Account.
5. Create a Google Cloud Storage bucket:
   ```bash
   gcloud storage buckets create gs://YOUR_BUCKET_NAME --location=YOUR_REGION
   ```
6. Copy the `openclaw.json` file to the root of the bucket.
   ```bash
   gcloud storage cp openclaw.json gs://YOUR_BUCKET_NAME/
   ```

## Deployment

Deploy with

```bash
gcloud alpha run instances create openclaw --image alpine/openclaw:latest \
  --port 18789 \
  --memory 2Gi \
  --no-invoker-iam-check \
  --add-volume mount-path=/home/node/.openclaw,type=cloud-storage,mount-options="uid=1000;gid=1000;file-mode=0777;dir-mode=0777",bucket=YOUR_BUCKET_NAME \
  --set-secrets GEMINI_API_KEY=gemini-api-key:latest,OPENCLAW_GATEWAY_PASSWORD=openclaw-gateway-password:latest
```

Open the URL

Enter the password (not the Gateway token)