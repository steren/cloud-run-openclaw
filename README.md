# cloud-run-openclaw
Deploy OpenClaw effortlessly on Google Cloud Run using standard Knative YAML configurations.

## Prerequisites

1. Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (`gcloud`) if you haven't already.
2. Authenticate with Google Cloud and set your project:
   ```bash
   gcloud auth login
   gcloud config set project $(gcloud config get-value project)
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
7. Create a dedicated service account and grant it necessary permissions:
   ```bash
   gcloud iam service-accounts create openclaw-sa --display-name="OpenClaw Service Account"
   gcloud storage buckets add-iam-policy-binding gs://YOUR_BUCKET_NAME \
     --member="serviceAccount:openclaw-sa@$(gcloud config get-value project).iam.gserviceaccount.com" \
     --role="roles/storage.objectAdmin"
   gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
     --member="serviceAccount:openclaw-sa@$(gcloud config get-value project).iam.gserviceaccount.com" \
     --role="roles/aiplatform.user"
   gcloud secrets add-iam-policy-binding gemini-api-key \
     --member="serviceAccount:openclaw-sa@$(gcloud config get-value project).iam.gserviceaccount.com" \
     --role="roles/secretmanager.secretAccessor"
   gcloud secrets add-iam-policy-binding openclaw-gateway-password \
     --member="serviceAccount:openclaw-sa@$(gcloud config get-value project).iam.gserviceaccount.com" \
     --role="roles/secretmanager.secretAccessor"
   ```

## Deployment

Deploy with

```bash
gcloud alpha run instances create clanker --image alpine/openclaw:latest \
  --service-account openclaw-sa@$(gcloud config get-value project).iam.gserviceaccount.com \
  --port 18789 \
  --cpu 4 \
  --memory 4Gi \
  --no-invoker-iam-check \
  --add-volume mount-path=/home/node/.openclaw,type=cloud-storage,mount-options="uid=1000;gid=1000;file-mode=0777;dir-mode=0777",bucket=YOUR_BUCKET_NAME \
  --set-secrets GEMINI_API_KEY=gemini-api-key:latest,OPENCLAW_GATEWAY_PASSWORD=openclaw-gateway-password:latest
```

## Connecting to OpenClaw

### 1. Web UI
1. Open the Cloud Run service URL in your browser.
2. Enter the password.
3. Confirm that you can chat with the bot.
4. Introduce yourself to the bot!

### 2. Connect to Telegram
1. On Telegram, contact **BotFather** to create a new bot.
2. Get the `botToken` from BotFather.
3. Provide the token to OpenClaw to connect it.

### 3. App Setup
To connect the OpenClaw desktop or mobile app:
1. Ask the Web UI for a setup code.
2. Add the password.
3. For the port, use `443`.
4. For the WebSocket URL, use `wss://<URL of the Cloud Run service>` (e.g., replace `https://` with `wss://`).