terraform {
  backend "s3" {
    # TODO: Replace these with your own unique bucket and table names before terraform init
    bucket         = "eks-idp-tf-state-eks-idp-bu"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "eks-idp-tf-locks-eks-idp-table"
    encrypt        = true
  }
}


