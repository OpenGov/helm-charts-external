# Upgrading the chart

```shell
# Assuming that you have GH checkouts structured with directories in the form <org>/<repo>
mkdir gravitational && cd gravitational
git clone https://github.com/gravitational/teleport.git
cd teleport
git checkout vX.Y.Z # checkout the release tag being upgraded to
cd ../../opengov/helm-charts-external
git checkout -B chart-upgrade/teleport-kube-agent/vX.Y.Z
cp -r ../../gravitational/teleport/examples/chart/teleport-kube-agent/* charts/teleport-kube-agent/
git commit -a
git push origin chart-upgrade/teleport-kube-agent/vX.Y.Z
gh pr create
# get it reviewed and merged
```
