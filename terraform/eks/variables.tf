variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-platform"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
