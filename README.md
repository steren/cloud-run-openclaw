# cloud-run-openclaw
Deploy OpenClaw effortlessly on Google Cloud Run using standard Knative YAML configurations.

## Prerequisites

1. Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (`gcloud`) if you haven't already.
2. Authenticate with Google Cloud and set your project:
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```
3. Create a `.env` file in the root of this project and set the environment variables:
   ```env
   OPENCLAW_GATEWAY_PASSWORD=your_secure_password
   GEMINI_API_KEY=your_actual_api_key
   ```
4. Create a Google Cloud Storage bucket:
   ```bash
   gcloud storage buckets create gs://YOUR_BUCKET_NAME --location=YOUR_REGION
   ```
5. Copy the `openclaw.json` file to the root of the bucket.
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
  --add-volume mount-path=/home/node/.openclaw,type=cloud-storage,bucket=YOUR_BUCKET_NAME \
  --env-vars-file .env
```

Open the URL

Enter the password (not the Gateaway token)