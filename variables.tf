variable "aws_region" {
  description = "AWS region where the exercise resources are created."
  type        = string
  default     = "us-east-1"
}

variable "github_owner" {
  description = "GitHub organization or username that owns the repository."
  type        = string
  default     = "f-magdiel"
}

variable "github_repo" {
  description = "GitHub repository allowed to assume the CI role."
  type        = string
  default     = "oyd-exercise-8-2"
}

variable "github_branch" {
  description = "Branch allowed to assume the CI role."
  type        = string
  default     = "main"
}

variable "database_password" {
  description = "Initial database password value stored in Secrets Manager."
  type        = string
  sensitive   = true
  default     = "changeme-in-rotation"
}
