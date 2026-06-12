output "ci_runner_role_arn" {
  description = "IAM role ARN used by GitHub Actions through OIDC federation."
  value       = aws_iam_role.ci_runner.arn
}

output "database_password_secret_arn" {
  description = "Secrets Manager ARN for the database password."
  value       = aws_secretsmanager_secret.database_password.arn
}
