variable "name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "role_arn" {
  description = "IAM role ARN for the EKS control plane"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster (typically private subnets)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Additional security groups to associate with the EKS cluster"
  type        = list(string)
  default     = []
}

variable "node_role_arn" {
  description = "IAM role ARN for the managed node group"
  type        = string
}

variable "node_subnet_ids" {
  description = "Subnet IDs where worker nodes will run (usually private subnets)"
  type        = list(string)
}

variable "node_instance_types" {
  description = "Instance types for worker nodes"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags to apply to all EKS resources"
  type        = map(string)
  default     = {}
}


