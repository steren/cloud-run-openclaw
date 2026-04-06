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

## Deployment

You can deploy the service to Cloud Run by running the deployment script:

```bash
./deploy.sh
```
