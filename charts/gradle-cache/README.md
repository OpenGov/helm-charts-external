# Gradle Cache Helm Chart

This chart installs a Gradle Cache node into your cluster. It is exposed via 
a service definition which is of type `ClusterIP` by default.

See [build cache docs](https://docs.gradle.com/build-cache-node/) for details

The cache node typically uses less than 100MB in disk space in practice (when used with Voltron services),
however it can be flushed via its UI.

## Persistent Volume Claim

This chart requests a PVC (via a stateful set). The PV is mounted to the internal cache BLOB store from inside
the running container. As it is part of a statefulset, it is durable across re-deployments.

## Useful URLs:

- Cache Node UI: `http://{{template "gradle.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local`
- Cache URL: `http://{{template "gradle.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local/cache/`