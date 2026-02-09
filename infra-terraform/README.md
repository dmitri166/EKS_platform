## Infra Terraform

This directory contains Terraform code for the cost-optimized EKS-based Internal Developer Platform.

Key design decisions for low cost:
- Single EKS cluster shared by `dev` and `prod` namespaces.
- Small managed node group (t3.micro/t3.small) with minimal replicas.
- Optional single-AZ or reduced AZ usage plus a single NAT Gateway.
- S3 + DynamoDB backend for Terraform state (low traffic, free-tier-friendly).

Do not store secrets here; use External Secrets Operator with AWS Secrets Manager or SSM.


