module "vpc" {
  source = "../../modules/vpc"

  name               = var.cluster_name
  cidr_block         = var.vpc_cidr_block
  az_count           = var.az_count
  single_nat_gateway = true
  tags               = var.tags
}

module "iam" {
  source = "../../modules/iam"

  name = var.cluster_name
  tags = var.tags
}

module "eks" {
  source = "../../modules/eks"

  name                = var.cluster_name
  role_arn            = module.iam.cluster_role_arn
  subnet_ids          = module.vpc.private_subnet_ids
  node_role_arn       = module.iam.node_role_arn
  node_subnet_ids     = module.vpc.private_subnet_ids
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  tags                = var.tags
}


