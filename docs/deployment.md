# Deployment Guide

## Prerequisites
- AWS CLI configured with credentials.
- Terraform v1.0+ installed.
- Git repository cloned.
- AWS account with required permissions.

## Bootstrap Infrastructure
1. Navigate to terraform/bootstrap: `cd terraform/bootstrap`
2. Initialize: `terraform init`
3. Plan: `terraform plan`
4. Apply: `terraform apply`

## Deploy EKS Cluster
1. Navigate to environments/dev: `cd ../environments/dev`
2. Initialize: `terraform init`
3. Plan: `terraform plan`
4. Apply: `terraform apply`

## Post-Deployment
- Update kubeconfig: `aws eks update-kubeconfig --name eks-platform-dev --region us-east-1`
- Deploy ArgoCD and sync apps.
