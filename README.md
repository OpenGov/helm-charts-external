# External Helm Charts

1. Create Personal Access token in Github and make sure it's SSO authorized in this [link](https://github.com/settings/tokens)

2. Create tgz file with chart in current directory:
```
helm package <app-name> 
```

3. Create index.yaml file which references application:
```
helm repo index . 
```

4. Add the repo to helm repo list:
```
helm repo add helm-external-repo  --username <github_username> --password <Personal Access Token> 'https://raw.githubusercontent.com/opengov/helm-charts-external/master/'
```

5. Check if repo exists in helm repo list:
```
helm repo update
helm repo list
```

6. In requirements file, can reference the application by adding as below:
```
  - name: <app_name>
    repository: "alias:helm-external-repo"
    version: <app_version>
```

OR:

```
  - name: <app_name>
    repository: "https://raw.githubusercontent.com/opengov/helm-charts-external/master/"
    version: <app_version>
```

## References
1. https://blog.softwaremill.com/hosting-helm-private-repository-from-github-ff3fa940d0b7
2. https://medium.com/hackernoon/using-a-private-github-repo-as-helm-chart-repo-https-access-95629b2af27c
