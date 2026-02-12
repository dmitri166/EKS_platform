module "eks" {
  source = "../eks"

  cluster_name = "eks-platform-prod"
  aws_region   = "us-east-1"

  # Pass variables as needed
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
