#!/bin/bash

# AWS Secrets Manager Setup Script
# Creates secrets for EKS platform

echo "🔐 Setting up AWS Secrets Manager secrets..."

# Backstage Database Credentials
echo "Creating Backstage database credentials..."
aws secretsmanager create-secret \
    --name "backstage-db-password" \
    --description "Backstage PostgreSQL database password" \
    --secret-string "$(openssl rand -base64 32)" \
    --region us-east-1

aws secretsmanager create-secret \
    --name "backstage-db-username" \
    --description "Backstage PostgreSQL database username" \
    --secret-string "backstage" \
    --region us-east-1

# Velero AWS Credentials
echo "Creating Velero AWS credentials..."
aws secretsmanager create-secret \
    --name "velero-aws-access-key" \
    --description "Velero AWS access key ID" \
    --secret-string "YOUR_VELERO_ACCESS_KEY" \
    --region us-east-1

aws secretsmanager create-secret \
    --name "velero-aws-secret-key" \
    --description "Velero AWS secret access key" \
    --secret-string "YOUR_VELERO_SECRET_KEY" \
    --region us-east-1

# ArgoCD Admin Credentials
echo "Creating ArgoCD admin credentials..."
aws secretsmanager create-secret \
    --name "argocd-admin-username" \
    --description "ArgoCD admin username" \
    --secret-string "admin" \
    --region us-east-1

aws secretsmanager create-secret \
    --name "argocd-admin-password" \
    --description "ArgoCD admin password" \
    --secret-string "$(openssl rand -base64 32)" \
    --region us-east-1

echo "✅ Secrets created successfully!"
echo ""
echo "📋 Secret List:"
aws secretsmanager list-secrets --region us-east-1 --query 'SecretList[*].Name' --output table

echo ""
echo "🔧 Next steps:"
echo "1. Deploy External Secrets Operator"
echo "2. Apply aws-secrets.yaml manifests"
echo "3. Update Velero access keys with your actual credentials"
echo "4. Test secret access in cluster"
