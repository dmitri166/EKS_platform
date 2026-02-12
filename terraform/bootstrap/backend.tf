terraform {
  backend "s3" {
    bucket         = "eks-platform-terraform-state-us-east-1"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "eks-platform-terraform-locks"
    encrypt        = true
  }
}
