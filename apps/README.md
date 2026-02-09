## Applications

This directory contains sample microservices and shared Helm charts used by the Internal Developer Platform.

Structure:
- `service-a/` – core demo service exposing health, readiness, metrics, and failure injection endpoints.
- `service-b/` – secondary service (optionally calling `service-a`) to demonstrate inter-service reliability patterns.
- `common-helm/` – reusable Helm chart for microservices, including:
  - Resource requests/limits tuned for small nodes.
  - Liveness/readiness probes.
  - PodDisruptionBudget and HPA.
  - Secure `securityContext` (non-root, read-only filesystem where possible).

These services are intentionally small to keep AWS and CI costs low while still demonstrating production-style patterns.


