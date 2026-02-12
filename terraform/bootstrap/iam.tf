# IAM roles and policies for Terraform bootstrap

resource "aws_iam_role" "terraform_bootstrap" {
  name = "terraform-bootstrap-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform-user"  # Replace with your IAM user or OIDC
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_bootstrap_admin" {
  role       = aws_iam_role.terraform_bootstrap.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"  # Scoped down in production
}

# S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "eks-platform-terraform-state-us-east-1"
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "eks-platform-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
