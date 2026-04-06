# cloud-run-openclaw
Deploy OpenClaw effortlessly on Google Cloud Run using standard Knative YAML configurations.

## Prerequisites

1. Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (`gcloud`) if you haven't already.
2. Authenticate with Google Cloud and set your project:
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```
3. Open `service.yaml` and replace `[YOUR_API_KEY]` with your actual GEMINI_API_KEY (or configure integration with Cloud Secret Manager mapping).
4. Open `openclaw.json` and replace `[your-password]` with a password of your choice.

## Deployment

You can deploy the service to Cloud Run by running:

```bash
gcloud run services replace service.yaml --region europe-west9
```

*(Feel free to update `--region` to point to the GCP region closest to you).*
