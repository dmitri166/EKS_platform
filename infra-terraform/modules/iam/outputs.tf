output "cluster_role_arn" {
  description = "IAM role ARN for the EKS control plane"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_role_arn" {
  description = "IAM role ARN for the EKS managed node group"
  value       = aws_iam_role.eks_node.arn
}


