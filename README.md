# cloud-run-openclaw
Deploy OpenClaw effortlessly on Google Cloud Run using standard Knative YAML configurations.

## Prerequisites

1. Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (`gcloud`) if you haven't already.
2. Authenticate with Google Cloud and set your project:
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```
3. Open `service.yaml` and update the environment variable `GEMINI_API_KEY` with your actual key (or configure integration with Cloud Secret Manager mapping).

## Deployment

You can deploy the service to Cloud Run by running:

```bash
gcloud run services replace service.yaml --region europe-west9
```

*(Feel free to update `--region` to point to the GCP region closest to you).*
