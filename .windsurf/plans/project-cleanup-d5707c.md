# Project Cleanup Plan

This plan identifies files and directories in the EKS platform project that can be safely deleted to clean up the repository.

## Files/Directories to Delete

- `.cursor/` - IDE-specific cursor position files
- `infra-terraform/envs/dev/.terraform/` - Terraform provider binaries (should not be committed to git)
- `infra-terraform/envs/dev/errored.tfstate` - Leftover state file from failed destroy operation
- `infra-terraform/terraform.tfstate` - Local state file (using remote S3 backend)

## Files to Review

- `apps/README.md` - Review content and determine if needed or can be relocated/removed

## Keep Files

All other files are necessary for the EKS platform infrastructure and GitOps setup, including:
- Terraform configuration files
- ArgoCD manifests and values
- GitOps application definitions
- Documentation files

## Implementation Steps

1. Delete the identified files/directories
2. Review `apps/README.md` and decide on action
3. Commit the cleanup changes
4. Push to repository

This cleanup will remove temporary and generated files while preserving the core project structure.
