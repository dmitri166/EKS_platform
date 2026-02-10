# Post-Terraform Apply Workflow

Comprehensive workflow for deploying and configuring the EKS platform after terraform apply, focusing on automation best practices for repeatable, production-ready deployments.

## Immediate Steps After Terraform Apply

1. **Verify Infrastructure**: Confirm EKS cluster, VPC, subnets, and security groups are created
   ```
   kubectl get nodes
   kubectl get svc
   aws eks describe-cluster --name eks-idp-dev
   ```

2. **Configure kubectl**: Update kubeconfig for the new cluster
   ```
   aws eks update-kubeconfig --name eks-idp-dev --region us-east-1
   ```

3. **Create Namespaces**: Apply namespace manifests
   ```
   kubectl apply -f platform-gitops/namespaces/
   ```

## ArgoCD Deployment and Configuration

1. **Deploy ArgoCD**: Apply the platform-root application
   ```
   kubectl apply -f platform-gitops/apps/platform-root-application.yaml
   ```

2. **Wait for ArgoCD**: Monitor deployment
   ```
   kubectl get pods -n platform -w
   ```

3. **Access ArgoCD UI**: Port-forward and login
   ```
   kubectl port-forward svc/argocd-server -n platform 8080:443
   # Login with admin/bIfQT8GBmgJCrCnv
   ```

4. **Configure Repository Credentials**: Add GitHub repo access
   ```
   argocd repo add https://github.com/dmitri166/EKS_platform --username dmitri166 --password <token>
   ```

5. **Sync Platform Applications**: ArgoCD will auto-sync or manually sync
   ```
   argocd app sync platform-root
   ```

## Application Deployment

1. **Verify Platform Stack**: Check all applications are healthy
   - cert-manager
   - external-secrets
   - ingress-nginx
   - loki-stack
   - kube-prometheus-stack

2. **Configure Ingress**: Update ingress host and apply
   ```
   kubectl apply -f platform-gitops/argocd/ingress.yaml
   # Get ELB hostname and update DNS
   ```

3. **Deploy Service Applications**: Update repo URLs and sync
   - Replace `REPLACE_ME_GIT_URL` in service YAMLs
   - ArgoCD will deploy automatically

## Security Configuration

1. **Apply Security Policies**: Network policies and pod security standards are auto-applied via ArgoCD

2. **Configure Secrets**: Set up external-secrets for AWS Secrets Manager

3. **RBAC Setup**: Ensure proper role-based access control

## Monitoring and Validation

1. **Access Grafana**: Port-forward and configure dashboards
   ```
   kubectl port-forward svc/loki-stack-grafana -n platform 3000:80
   # admin/prom-operator
   ```

2. **Verify Prometheus**: Check metrics collection
   ```
   kubectl port-forward svc/prometheus-operated -n platform 9090:9090
   ```

3. **Test Ingress**: Verify external access to ArgoCD and services

## Automation Best Practices

### Current Automation Level
- ✅ Infrastructure as Code (Terraform)
- ✅ GitOps (ArgoCD)
- ✅ Automated application deployment
- ✅ Security policy enforcement
- ✅ Monitoring stack deployment

### Full Automation Pipeline (Recommended)

1. **CI/CD Setup**: Implement GitHub Actions/Azure DevOps for automated deployment
   - Terraform plan/apply on PR/infrastructure changes
   - ArgoCD sync on application updates
   - Automated testing and validation

2. **Infrastructure Automation**:
   - Use Terraform Cloud/Enterprise for remote execution
   - Implement policy checks (Open Policy Agent)
   - Automated cost optimization

3. **Application Automation**:
   - GitOps workflows for application promotion
   - Automated testing pipelines
   - Rollback strategies

4. **Security Automation**:
   - Automated vulnerability scanning
   - Policy enforcement via admission controllers
   - Compliance monitoring

5. **Monitoring Automation**:
   - Automated alerting setup
   - Dashboard provisioning
   - Log aggregation and analysis

## Implementation Steps for Full Automation

1. **Set up CI/CD Pipeline**:
   - Create GitHub Actions workflow for terraform
   - Configure ArgoCD CLI integration
   - Implement automated testing

2. **Infrastructure Automation**:
   - Configure Terraform remote backend
   - Add policy checks and validation
   - Implement drift detection

3. **Application Lifecycle**:
   - Set up staging/production environments
   - Implement blue-green deployments
   - Configure automated rollbacks

4. **Security Automation**:
   - Integrate security scanning tools
   - Set up automated compliance checks
   - Implement secret rotation

5. **Operational Automation**:
   - Configure automated backups
   - Set up auto-scaling
   - Implement cost monitoring

## Cost Optimization for Automation

- Use spot instances for CI/CD runners
- Implement resource quotas and limits
- Schedule non-production workloads
- Monitor and optimize cloud costs

## Summary

The current setup follows excellent best practices with Terraform and ArgoCD providing solid automation foundations. For full automation, implement a CI/CD pipeline that orchestrates terraform deployments and ArgoCD syncs, with comprehensive testing and security checks. This enables fully automated, repeatable deployments from code changes to production.
