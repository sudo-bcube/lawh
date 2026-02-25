# Google Cloud Setup

This document explains how to configure Google Cloud Speech-to-Text credentials for Lawh.

---

## Overview

Lawh uses Google Cloud Speech-to-Text API to transcribe Arabic Quranic audio. The backend supports three authentication methods:

| Method | Use Case | Environment Variable |
|--------|----------|---------------------|
| Base64 JSON | Production deployments | `GOOGLE_CREDENTIALS_JSON_BASE64` |
| File path | Local development | `GOOGLE_CREDENTIALS_PATH` |
| Default credentials | GCP-hosted (Cloud Run, GKE) | None needed |

---

## Initial Setup (One-time)

### 1. Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select existing one
3. Note your **Project ID**

### 2. Enable Speech-to-Text API

1. Go to **APIs & Services** → **Enable APIs and Services**
2. Search for "Cloud Speech-to-Text API"
3. Click **Enable**

### 3. Create Service Account

1. Go to **IAM & Admin** → **Service Accounts**
2. Click **Create Service Account**
3. Fill in:
   - **Name:** `lawh-stt`
   - **Description:** `Speech-to-Text API access for Lawh app - transcribes Arabic Quranic audio recordings`
4. Click **Create and Continue**
5. Select role: **Cloud Speech** → **Cloud Speech Client**
6. Click **Continue** → **Done**

### 4. Generate JSON Key

1. Click on the service account you created
2. Go to **Keys** tab
3. Click **Add Key** → **Create New Key**
4. Select **JSON**
5. Save the downloaded file as `lawh-creds.json`

---

## Local Development

Place the credentials file in the backend directory and reference it in `.env`:

```bash
# backend/.env
GOOGLE_CREDENTIALS_PATH=lawh-creds.json
```

**Important:** The file is gitignored. Never commit credentials to the repository.

---

## Production Deployment

### Option 1: Base64-Encoded Environment Variable (Recommended)

Works with any hosting platform (Render, Railway, Heroku, AWS, etc.)

**Step 1: Encode the credentials**
```bash
base64 -i lawh-creds.json | tr -d '\n'
```

**Step 2: Set environment variable in your deployment platform**
```
GOOGLE_CREDENTIALS_JSON_BASE64=eyJ0eXBlIjoic2VydmljZV9hY2NvdW50IiwicHJvamVjdF9pZCI6...
```

### Option 2: Default Credentials (GCP-hosted only)

If deploying to Google Cloud (Cloud Run, GKE, Compute Engine):

1. Attach the service account to your deployment
2. No environment variables needed - credentials are automatic

---

## Environment Variables Reference

| Variable | Required | Description |
|----------|----------|-------------|
| `GOOGLE_CREDENTIALS_JSON_BASE64` | Production | Base64-encoded service account JSON |
| `GOOGLE_CREDENTIALS_PATH` | Local dev | Path to service account JSON file |
| `GOOGLE_PROJECT_ID` | Optional | Google Cloud project ID |

**Priority order:** Base64 → File path → Default credentials

---

## Troubleshooting

### "Could not automatically determine credentials"

- Ensure one of the environment variables is set
- For local dev: Check that `lawh-creds.json` exists at the specified path
- For production: Verify the base64 string is correctly encoded

### "Permission denied" or "403 Forbidden"

- Verify the service account has the **Cloud Speech Client** role
- Check that the Speech-to-Text API is enabled in your project

### "Invalid base64" error

- Ensure no newlines in the base64 string: `base64 -i file.json | tr -d '\n'`
- Some platforms require the string without padding - try removing trailing `=` characters

---

## Security Notes

1. **Never commit credentials** - `lawh-creds.json` is in `.gitignore`
2. **Rotate keys periodically** - Delete old keys in Google Cloud Console
3. **Use least privilege** - The service account only has Speech-to-Text access
4. **Monitor usage** - Set up billing alerts in Google Cloud Console

---

## Cost Estimate

Google Cloud Speech-to-Text pricing (as of 2024):

| Usage | Cost |
|-------|------|
| First 60 minutes/month | Free |
| After free tier | ~$0.006 per 15 seconds |

For Lawh (10-15 second recordings):
- ~$0.006 per search
- ~1,000 searches = ~$6
- ~10,000 searches = ~$60

Set up budget alerts at **Billing** → **Budgets & alerts** in Google Cloud Console.
