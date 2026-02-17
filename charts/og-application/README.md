# og-application

A reusable Helm chart for XOPS Kubernetes deployments. Published from [helm-charts-external](https://github.com/OpenGov/helm-charts-external) (no Artifactory auth required).

## How to Deploy Your Application

To deploy your application, you only need to create **2 files**:

1. `values.yaml` - Your application configuration
2. `kustomization.yaml` - Reference to this chart

That's it! The chart handles all the Kubernetes manifests for you.

---

## Quick Start

### Step 1: Create your values file

```yaml
# my-app.values.yaml
fullnameOverride: my-app

image:
  repository: 918073871806.dkr.ecr.us-west-2.amazonaws.com/my-app
  tag: latest

service:
  port: 8080

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

### Step 2: Create your kustomization file

```yaml
# kustomization.yaml
helmCharts:
  - name: og-application
    repo: https://opengov.github.io/helm-charts-external/
    version: 1.0.7
    releaseName: my-app
    namespace: my-namespace
    valuesFile: my-app.values.yaml
```

### Step 3: Build and verify (optional)

```bash
kustomize build --enable-helm .
```

---

## What Gets Created

The chart automatically creates these Kubernetes resources based on your values:

| Resource | Created When |
|----------|-------------|
| Deployment | Always |
| Service | `service.enabled: true` (default) |
| ServiceAccount | `serviceAccount.create: true` (default) |
| Ingress | `ingress.enabled: true` |
| ConfigMap | `configMap.enabled: true` |
| ExternalSecret | `externalSecret.enabled: true` |
| HPA | `autoscaling.enabled: true` |
| PDB | `podDisruptionBudget.enabled: true` (default) |

---

## Common Configurations

### Enable Ingress

```yaml
ingress:
  enabled: true
  hosts:
    - host: my-app.example.com
      paths:
        - path: /
          pathType: Prefix
```

### Enable External Secrets

```yaml
externalSecret:
  enabled: true
  data:
    - secretKey: DATABASE_URL
      remoteRef:
        key: my-app/secrets
        property: database_url
```

### Enable Autoscaling

```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
```

---

## All Configuration Options

See [values.yaml](values.yaml) for the complete list of configurable options.

---

## Support

Contact: XOPS Platform Team (#engineering-platform on Slack)
