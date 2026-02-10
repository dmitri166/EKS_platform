# ArgoCD Automation Script Plan

Create a local bash script to automate ArgoCD deployment and configuration commands after terraform apply, enabling repeatable and automated platform setup.

## Script Purpose

Automate the post-terraform apply workflow for ArgoCD:
- Deploy ArgoCD application
- Configure port-forwarding
- Login to ArgoCD
- Add repository credentials
- Sync platform applications
- Provide status and next steps

## Commands to Automate

```bash
#!/bin/bash

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

# Login to ArgoCD
echo "Logging into ArgoCD..."
argocd login localhost:8080 --username admin --password bIfQT8GBmgJCrCnv --insecure

# Add repository (requires token input)
echo "Adding GitHub repository..."
read -p "Enter GitHub personal access token: " GITHUB_TOKEN
argocd repo add https://github.com/dmitri166/EKS_platform --username dmitri166 --password $GITHUB_TOKEN

# Sync platform applications
echo "Syncing platform applications..."
argocd app sync platform-root

# Provide access information
echo "ArgoCD setup complete!"
echo "UI Access: https://localhost:8080"
echo "Admin Password: bIfQT8GBmgJCrCnv"
echo "Port-forward PID: $PORT_FORWARD_PID (kill with: kill $PORT_FORWARD_PID)"

# Keep port-forward running
wait $PORT_FORWARD_PID
```

## Script Implementation

1. Create `scripts/deploy-argocd.sh` with the above content
2. Make executable: `chmod +x scripts/deploy-argocd.sh`
3. Run after terraform apply: `./scripts/deploy-argocd.sh`

## What to Do After Script Execution

1. **Verify ArgoCD UI Access**: Open https://localhost:8080 and login
2. **Check Application Status**: Ensure all platform applications are synced and healthy
3. **Configure Ingress**: Update and apply ArgoCD ingress for permanent access
4. **Apply Security Policies**: Ensure network policies and pod security standards are applied
5. **Access Monitoring**: Port-forward Grafana and Prometheus for dashboard access
6. **Deploy Service Applications**: Update repo URLs in service YAMLs and sync
7. **Validate Security**: Test network policies and security controls

## Best Practices for Automation

- **Error Handling**: Add error checking and retries
- **Secrets Management**: Avoid hardcoding passwords; use environment variables or prompts
- **Logging**: Add verbose logging for troubleshooting
- **Cleanup**: Include cleanup commands for port-forwards and temporary resources
- **CI/CD Integration**: Adapt script for automated pipelines

## Advanced Automation Features

- **Wait Conditions**: Add proper waiting for pod readiness
- **Health Checks**: Verify application health before proceeding
- **Rollback**: Include rollback commands for failed deployments
- **Notifications**: Add Slack/email notifications for deployment status

## Implementation Steps

1. Create the script file with automated commands
2. Test the script in development environment
3. Add error handling and logging
4. Integrate with CI/CD pipeline for full automation
5. Document the script and maintenance procedures

This script provides a single-command deployment of ArgoCD with all necessary configuration, significantly simplifying the post-terraform apply workflow.
