# og-application Chart Maintenance

## Publishing a New Release

1. **Make your changes** in `charts/og-application/` (templates, values.yaml, etc.)

2. **Bump the version** in `Chart.yaml`:
   ```yaml
   version: 1.0.8  # Increment (e.g., 1.0.7 → 1.0.8)
   ```

3. **Open a PR** and merge to `master`:
   ```bash
   git checkout -b update-og-application-1.0.8
   git add charts/og-application/
   git commit -m "og-application: bump to 1.0.8"
   git push origin update-og-application-1.0.8
   # Open PR on GitHub
   ```

4. **Automatic release** – On merge to `master`, the [Release Charts](.github/workflows/release-charts.yaml) workflow will:
   - Package the chart
   - Create a GitHub Release (e.g. `og-application-1.0.8`)
   - Update the Helm index at `https://opengov.github.io/helm-charts-external/`

## Consuming the Chart

**Helm:**
```bash
helm repo add opengov-external https://opengov.github.io/helm-charts-external/
helm install my-app opengov-external/og-application --values values.yaml
```

**Kustomize (helmCharts):**
```yaml
helmCharts:
  - name: og-application
    repo: https://opengov.github.io/helm-charts-external/
    version: 1.0.7
    releaseName: my-app
    namespace: my-namespace
    valuesFile: values.yaml
```

## Source of Truth

This chart is maintained in [helm-charts-external](https://github.com/OpenGov/helm-charts-external). The original source was [og-shared-xops-kit](https://github.com/OpenGov/og-shared-xops-kit); use this repo for future updates to avoid Artifactory 401 auth issues.
