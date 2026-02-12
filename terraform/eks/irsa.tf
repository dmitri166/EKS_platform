# IRSA roles for Kubernetes components

data "aws_iam_policy_document" "external_secrets" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "external_secrets_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:platform:external-secrets-sa"]
    }
  }
}

resource "aws_iam_policy" "external_secrets" {
  name        = "external-secrets-policy"
  description = "Policy for External Secrets Operator"

  policy = data.aws_iam_policy_document.external_secrets.json
}

resource "aws_iam_role" "external_secrets" {
  name               = "external-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume_role.json
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets.arn
}

# Add more IRSA roles as needed for ALB controller, etc.
