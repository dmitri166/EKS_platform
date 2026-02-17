# AWS Secrets Manager Setup Guide

## 🎯 Overview
This guide sets up production-grade secrets management using AWS Secrets Manager for the EKS platform.

## 📋 Secrets Being Created

### 1. Backstage Database
- **backstage-db-password**: Random 32-character password
- **backstage-db-username**: "backstage" (static)

### 2. Velero Backup
- **velero-aws-access-key**: Your Velero AWS access key
- **velero-aws-secret-key**: Your Velero AWS secret key

### 3. ArgoCD Admin
- **argocd-admin-username**: "admin" (static)
- **argocd-admin-password**: Random 32-character password

## 🚀 Setup Instructions

### Step 1: Create AWS Secrets
```bash
# Make script executable
chmod +x scripts/setup-secrets.sh

# Run setup script
./scripts/setup-secrets.sh
```

### Step 2: Update Velero Credentials
Edit `scripts/setup-secrets.sh` and replace:
- `YOUR_VELERO_ACCESS_KEY` with your actual AWS access key
- `YOUR_VELERO_SECRET_KEY` with your actual AWS secret key

### Step 3: Deploy External Secrets
```bash
# Apply secrets manifests
kubectl apply -f secrets/aws-secrets.yaml

# Verify secrets created
kubectl get externalsecrets -A
kubectl get secrets -A
```

### Step 4: Test Integration
```bash
# Test Backstage secret access
kubectl get secret backstage-db-credentials -n monitoring -o yaml

# Test Velero secret access
kubectl get secret velero-credentials -n velero -o yaml
```

## 💰 Cost Analysis

### Monthly Costs
- **5 secrets × $0.40** = $2.00
- **API calls (~5,000)** = $0.025
- **Total monthly**: ~$2.03

### Free Tier
- **60 days free** available
- **Perfect for evaluation**
- **Production-ready** after trial

## 🔐 Security Benefits

### Before
- ❌ Plain text passwords in Git
- ❌ No encryption at rest
- ❌ No access control
- ❌ No audit logging

### After
- ✅ AES-256 encryption at rest
- ✅ IAM-based access control
- ✅ Full audit logging
- ✅ Automatic rotation support
- ✅ Centralized management

## 🎯 Production Best Practices

### 1. Secret Rotation
```bash
# Enable automatic rotation (90 days)
aws secretsmanager rotate-secret \
    --secret-id backstage-db-password \
    --rotation-rules AutomaticallyAfterDays=90
```

### 2. Access Monitoring
```bash
# Monitor secret access
aws logs filter-log-events \
    --log-group-name /aws/secretsmanager \
    --start-time $(date -d '24 hours ago' --iso-8601)
```

### 3. Compliance
- ✅ SOC 2 compliant
- ✅ GDPR ready
- ✅ HIPAA compatible
- ✅ PCI DSS aligned

## 🔄 Next Steps

1. **Run setup script** to create secrets
2. **Update Velero credentials** with your actual keys
3. **Deploy secrets manifests** to cluster
4. **Test secret access** and functionality
5. **Enable rotation** for production use

## 📞 Support

For issues with secret access:
1. Check IRSA permissions in `terraform/eks/irsa.tf`
2. Verify External Secrets Operator deployment
3. Review AWS CloudTrail logs for access attempts
4. Test secret retrieval manually with AWS CLI
