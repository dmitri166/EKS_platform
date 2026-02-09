## Platform GitOps

This directory contains Argo CD applications and configuration that define the platform and workloads.

Principles:
- Git is the single source of truth for cluster configuration.
- Argo CD continuously reconciles the cluster state to match this repo.
- Auto-sync for `dev`, manual sync or PR-based promotion for `prod`.

Cost-aware setup:
- Single EKS cluster with separate `dev`, `prod`, and `platform` namespaces.
- Single ingress controller and shared load balancer with host/path-based routing.
- Slimmed observability stack (single replica components, short retention).


