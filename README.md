# cloud-run-openclaw
Deploy OpenClaw effortlessly on Google Cloud Run using standard Knative YAML configurations.

## Prerequisites

1. Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (`gcloud`) if you haven't already.
2. Authenticate with Google Cloud and set your project:
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```
3. Create a `.env` file in the root of this project and set your password and API key:
   ```env
   OPENCLAW_GATEWAY_PASSWORD=your_secure_password
   GEMINI_API_KEY=your_actual_api_key
   ```
4. Create a Google Cloud Storage bucket:
   ```bash
   gcloud storage buckets create gs://YOUR_BUCKET_NAME --location=YOUR_REGION
   ```
5. Copy the `.env` and `openclaw.json` files at the root of the bucket.
   ```bash
   gcloud storage cp openclaw.json .env gs://YOUR_BUCKET_NAME/
   ```

## Deployment

Deploy with

```bash
gcloud beta run deploy openclaw --image alpine/openclaw:latest \
  --port 18789 \
  --memory 4Gi \
  --scaling 1 \
  --no-cpu-throttling \
  --no-invoker-iam-check \
  --add-volume mount-path=/home/node/.openclaw,type=cloud-storage,bucket=YOUR_BUCKET_NAME
```
