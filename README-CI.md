## Infrastructure CI/CD (GitHub Actions)

This document explains how the repository’s GitHub Actions workflow deploys and destroys infrastructure from YAML configurations using the Python scripts and Terraform.

### Overview
- Reads intent from commit messages or manual inputs.
- Runs `Scripts/deploy.py` (deploy) or `Scripts/destroy.py` (destroy) for the specified YAML files in `Configs/`.
- Plans by default; applies only when explicitly approved.
- Commits the generated `<project_id>/` directory back to the repository (excluding `.terraform`).

### Prerequisites
- Secrets
  - `PERSONAL_GCP_CREDENTIALS`: Full JSON content of a GCP service account key with permissions to plan/apply/destroy your resources. The workflow exports it to `GOOGLE_APPLICATION_CREDENTIALS`.
  - Optional: `SLACK_WEBHOOK_URL` for success/failure notifications.

### Triggers
- Push to `main` with specific commit messages (see below), or
- Manual dispatch from the GitHub Actions UI.

### Commit Message Commands
- Deploy (plan only):
  - `deploy`
  - `deploy Configs/project-01.yaml`
- Deploy (apply):
  - `deploy yes`
  - `deploy Configs/project-01.yaml yes`
- Destroy (plan-destroy only):
  - `destroy`
  - `destroy Configs/project-01.yaml`
- Destroy (apply):
  - `destroy yes`
  - `destroy Configs/project-01.yaml yes`

Notes:
- If you use lowercase `configs/...` in the commit message, the workflow maps it to `Configs/...` automatically.
- If you do not specify file paths, the workflow targets changed files under `Configs/` in the pushed commit.

### Manual Dispatch Inputs
- `action`: `deploy` or `destroy`.
- `files` (optional): Space‑separated YAML paths, e.g. `Configs/project-01.yaml Configs/project-02.yaml`.
- `approve` (optional): `yes` to apply/destroy; omit for plan-only.

### Plan vs Apply Behavior
- Without `yes` (or `approve=yes`), the workflow pipes “no” into the scripts so they show a plan and do not apply.
- With `yes`, the scripts run non‑interactive apply/destroy.
- Important: The Google Terraform provider typically requires valid credentials even for plan. Ensure `PERSONAL_GCP_CREDENTIALS` is a valid service account JSON to see plan output in CI.

### Destroy Scope
`Scripts/destroy.py` supports a scope prompt:
- `modules`: Terraform destroy only.
- `all`: Terraform destroy, then delete the generated `<project_id>/` folder.

In CI, you can set `DESTROY_SCOPE=modules` or `DESTROY_SCOPE=all` to skip the prompt.

### Repository Persistence
After each run, the workflow stages and commits the generated `<project_id>/` directory (excluding `.terraform`) with a CI commit message, then pushes to the same branch.

### Local Usage (Windows PowerShell)
From the repository root:

1) Authenticate (recommended for apply/destroy):
```
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\service-account.json"
$env:CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$env:GOOGLE_APPLICATION_CREDENTIALS
```
Or via gcloud:
```
gcloud auth application-default login
```

2) Run scripts:
```
# Plan only
echo no | python Scripts\deploy.py Configs\project-01.yaml

# Apply
echo yes | python Scripts\deploy.py Configs\project-01.yaml

# Plan destroy
echo no | python Scripts\destroy.py Configs\project-01.yaml

# Destroy
echo yes | python Scripts\destroy.py Configs\project-01.yaml
```

### Troubleshooting
- “Invalid provider configuration” or ADC errors during plan:
  - Ensure `PERSONAL_GCP_CREDENTIALS` is set and contains a complete, valid service account JSON.
  - Confirm the service account has required roles (e.g., for project creation and resource management) and that billing/organization constraints are met.
- Workflow detected no files:
  - Ensure paths are under `Configs/` or pass explicit file paths in the commit message or manual inputs.


