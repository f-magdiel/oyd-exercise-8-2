terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6"
}

provider "aws" {
  region = var.aws_region
}

locals {
  project_name = "oyd-exercise-8-2"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
  ]
}

data "aws_iam_policy_document" "ci_runner_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github.arn,
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/${var.github_branch}",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "ci_runner" {
  name               = "${local.project_name}-ci-runner"
  assume_role_policy = data.aws_iam_policy_document.ci_runner_assume_role.json
}

data "aws_iam_policy_document" "ci_runner_permissions" {
  statement {
    sid    = "AllowIdentityCheck"
    effect = "Allow"

    actions = [
      "sts:GetCallerIdentity",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "AllowTerraformReadAccess"
    effect = "Allow"

    actions = [
      "iam:Get*",
      "iam:List*",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "ci_runner" {
  name   = "${local.project_name}-terraform-validate"
  role   = aws_iam_role.ci_runner.id
  policy = data.aws_iam_policy_document.ci_runner_permissions.json
}

resource "aws_secretsmanager_secret" "database_password" {
  name        = "${local.project_name}-db-password"
  description = "Database password used by ${local.project_name}."
}

resource "aws_secretsmanager_secret_version" "database_password" {
  secret_id     = aws_secretsmanager_secret.database_password.id
  secret_string = var.database_password

  lifecycle {
    ignore_changes = [
      secret_string,
    ]
  }
}
