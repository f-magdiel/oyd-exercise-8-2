# oyd-exercise-8-2

Terraform configuration for Exercise 8.2: GitHub Actions OIDC federation with AWS IAM and Secrets Manager.

## Resources

- GitHub Actions OIDC provider for `https://token.actions.githubusercontent.com`
- IAM role for the CI runner with an exact `StringEquals` trust condition for `repo:f-magdiel/oyd-exercise-8-2:ref:refs/heads/main`
- Secrets Manager secret named `oyd-exercise-8-2-db-password`
- Terraform outputs for the CI role ARN and secret ARN

## Apply

If the repository owner is not `f-magdiel`, update `github_owner` before applying.

```bash
terraform init
terraform validate
terraform apply -auto-approve
```

The workflow uses the applied CI role ARN directly in `role-to-assume` and does not require stored AWS access keys. Push to `main` to run the workflow.
