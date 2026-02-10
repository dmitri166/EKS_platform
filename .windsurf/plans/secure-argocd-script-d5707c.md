# Secure ArgoCD Automation Script Plan

Update the ArgoCD automation script to securely handle the admin password using environment variables instead of hardcoding, following security best practices.

## Security Issue Identified

The original script hardcodes the ArgoCD admin password in plain text, which:
- Exposes sensitive credentials in version control
- Creates security vulnerabilities
- Violates least privilege and secrets management principles

## Security Solutions

### Option 1: Environment Variable (Recommended)
```bash
# Set password securely
export ARGOCD_PASSWORD="your-secure-password"

# Use in script
argocd login localhost:8080 --username admin --password $ARGOCD_PASSWORD --insecure
```

### Option 2: Interactive Prompt
```bash
# Prompt for password
read -s -p "Enter ArgoCD admin password: " ARGOCD_PASSWORD
echo

# Use in script
argocd login localhost:8080 --username admin --password $ARGOCD_PASSWORD --insecure
```

### Option 3: External Secrets Management
- Store password in AWS Secrets Manager
- Retrieve via external-secrets operator
- Use in automation scripts

## Updated Script Implementation

```bash
#!/bin/bash

# Secure password handling
if [ -z "$ARGOCD_PASSWORD" ]; then
    echo "Error: ARGOCD_PASSWORD environment variable not set"
    echo "Set it with: export ARGOCD_PASSWORD='your-password'"
    exit 1
fi

# Deploy ArgoCD
echo "Deploying ArgoCD..."
kubectl apply -f platform-gitops/apps/platform-root-application.yaml

# Wait for ArgoCD pods
echo "Waiting for ArgoCD pods..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n platform --timeout=300s

# Port-forward ArgoCD server
echo "Starting port-forward for ArgoCD UI..."
kubectl port-forward svc/argocd-server -n platform 8080:443 &
PORT_FORWARD_PID=$!

# Wait for port-forward to establish
sleep 5

# Login to ArgoCD (secure)
echo "Logging into ArgoCD..."
argocd login localhost:8080 --username admin --password $ARGOCD_PASSWORD --insecure

# Add repository (requires token input)
echo "Adding GitHub repository..."
read -s -p "Enter GitHub personal access token: " GITHUB_TOKEN
echo
argocd repo add https://github.com/dmitri166/EKS_platform --username dmitri166 --password $GITHUB_TOKEN

# Sync platform applications
echo "Syncing platform applications..."
argocd app sync platform-root

# Provide access information
echo "ArgoCD setup complete!"
echo "UI Access: https://localhost:8080"
echo "Port-forward PID: $PORT_FORWARD_PID (kill with: kill $PORT_FORWARD_PID)"

# Keep port-forward running
wait $PORT_FORWARD_PID
```

## Security Best Practices

1. **Never hardcode passwords** in scripts or configuration files
2. **Use environment variables** for sensitive values
3. **Implement password rotation** regularly
4. **Store secrets securely** using dedicated secret management tools
5. **Limit script access** to authorized users only
6. **Audit credential usage** and monitor for unauthorized access

## Implementation Steps

1. Update script to use environment variable for password
2. Add password validation and error handling
3. Document secure usage in README
4. Implement password rotation procedures
5. Add security scanning for credential leaks

## Usage Instructions

```bash
# Set password securely
export ARGOCD_PASSWORD="your-secure-password"

# Run script
./scripts/deploy-argocd.sh
```

## Alternative Secure Methods

- **HashiCorp Vault**: Store secrets in Vault and retrieve via API
- **AWS Secrets Manager**: Use external-secrets to retrieve passwords
- **Kubernetes Secrets**: Store in K8s secrets with proper RBAC
- **Password Managers**: Use 1Password or similar for credential management

This updated approach ensures sensitive credentials are not exposed in code while maintaining automation capabilities.
