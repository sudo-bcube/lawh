# Infrastructure and Deployment

[Back to Architecture Index](../index.md)

---

## Infrastructure as Code

- **Tool:** Terraform 1.7.x
- **Location:** `infrastructure/`
- **State:** DigitalOcean Spaces (S3-compatible)

## Resources

| Resource | Staging | Production |
|----------|---------|------------|
| DigitalOcean Droplet | $6/month | $12/month |
| Managed PostgreSQL | $15/month | $15/month |
| DigitalOcean Spaces | $5/month | $5/month |
| **Total** | **$26/month** | **$32/month** |

## Deployment Strategy

- **Strategy:** Rolling Update
- **CI/CD Platform:** GitHub Actions
- **Mobile Builds:** Codemagic

## Environments

| Environment | Purpose | URL |
|-------------|---------|-----|
| Local | Development | `http://localhost:8000` |
| Staging | Pre-production | `https://staging-api.lawh.app` |
| Production | Live users | `https://api.lawh.app` |

## Environment Promotion Flow

```
Local → Staging → Production
(Feature branch) → (main branch, auto-deploy) → (Tagged release, manual approval)
```

## Rollback Strategy

- **Primary Method:** Git revert + redeploy
- **Recovery Time Objective:** 15 minutes
- **Database:** Alembic migrations are reversible, daily backups retained 30 days

## Fallback Hosting

If DigitalOcean has issues, deploy to Heroku Eco ($7/month) + Mini PostgreSQL ($5/month).
