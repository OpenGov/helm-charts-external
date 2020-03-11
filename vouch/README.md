Vouch Proxy
=====
An SSO and OAuth login solution for nginx using the auth_request module.

[Vouch Proxy](https://github.com/vouch/vouch-proxy) supports many OAuth including Okta login providers and can enforce authentication.
Current chart version is `0.1.3`

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"voucher/vouch-proxy"` |  |
| image.tag | string | `"{{ .Chart.AppVersion }}"` |  |
| nameOverride | string | `""` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |

The Helm Chart we are using is maintained by [halkeye](https://github.com/halkeye) and are available at this [repository](https://github.com/halkeye-helm-charts/vouch).