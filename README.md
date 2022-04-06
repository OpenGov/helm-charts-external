# External Helm Charts

## Usage with Helm

1. Add the repo to helm repo list:

```bash
helm repo add opengov-external 'https://opengov.github.io/helm-charts-external/'
```

1. Check if repo exists in helm repo list:

```bash
helm repo update
helm repo list
```

1. Use a chart

```bash
helm install opengov-external/$CHART $RELEASE_NAME --values $VALUES
```

## Usage with Kustomize

In your `kustomize.yaml`:

```yaml
---
helmCharts:
- name: chart-name
  repo: https://opengov.github.io/helm-charts-external
  version: vX.Y.Z
  releaseName: chart-name
  namespace: chart-namespace
  valuesFile: values.yaml
  valuesInline:
    image: "imagename:tag"
```

## Updating the Charts

1. Fetch the chart version you want to update to

```bash
cd charts/
helm fetch repo/chart --version X.Y.Z
```

1. Extract the chart

```bash
tar xjf chart-X.Y.Z.tgz
```

1. Commit changes and open a PR

```bash
git checkout -B ticket-123-update-chart
git add chart/
git commit
git push ticket-123-update-chart
gh pr create # or open in the GH UI
```

## Releasing the charts

1. The GitHub Actions Workflow [.github/workflows/release_charts.yml](.github/workflows/release_charts.yml) will handle it on merge to `master`

## References

1. https://blog.softwaremill.com/hosting-helm-private-repository-from-github-ff3fa940d0b7
1. https://medium.com/hackernoon/using-a-private-github-repo-as-helm-chart-repo-https-access-95629b2af27c
1. https://medium.com/@mattiaperi/create-a-public-helm-chart-repository-with-github-pages-49b180dbb417
