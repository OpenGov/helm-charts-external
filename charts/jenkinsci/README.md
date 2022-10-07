# Jenkinsci helm chart
This is a helm chart that wraps the stable/jenkins helm chart.
It allows us to configure a standard starting place for ci.

# Continuous Integration
See [here](https://opengovinc.atlassian.net/wiki/spaces/ENGR/pages/341704855/Continuous+Integration)!

# Usage

## Minikube Prep

### Setup and run minikube

```bash
brew cask install minikube
minikube start --memory 8192 --cpus 2

# a bit later
minikube dashboard --url
```

## Configuration

Secrets under the following keys map to these Jenkins secret types, and must contain the 'Required Value Fields' as keys:

|                  Key                  |            Jenkins Secret Type            |    Required Value Fields     |
|---------------------------------------|-------------------------------------------|------------------------------|
| `secrets.usernamePasswordType`        |   Username with password                  | `id.username`, `id.password` |
| `secrets.secretTextType`              |   Secret text                             | `id`                         |


The following tables lists required configurable parameters of the chart, these should be set in the `secrets.yaml` ([example](secrets.example.yaml)) file:

|                  Parameter                 |            Description             |                    Default                |
|--------------------------------------------|------------------------------------|-------------------------------------------|
| `repositories`                                                  | List of GitHub repositories for Jenkins to automatically monitor. Should be in the format of **https://github.com/OpenGov/${REPO_NAME}.git**. If you want to seed from a specific branch on a repository, then the branch name can be specified after the repository URL delimited by a semicolon: **https://github.com/OpenGov/${REPO_NAME}.git;${BRANCH_NAME}** . | Default list set in the `values.yaml` |
| `secrets.usernamePasswordType.github.username`                  | GitHub user                        |  `Nil` You must provide your own user     |
| `secrets.usernamePasswordType.github.password`                  | GitHub user personal access token  |  `Nil` You must provide your own token    |
| `secrets.usernamePasswordType.dockerhub-push.username`          | DockerHub user name                |  `Nil` You must provide your own user     |
| `secrets.usernamePasswordType.dockerhub-push.password`          | Docker registry user               |  `Nil` You must provide your own email    |
| `secrets.usernamePasswordType.deployment-secrets-aws.username`  | Jenkins Kubernetes deployment pipeline Access Key ID. Must have read only S3 access to the following buckets, across several accounts: test - s3://og-test-k8s-secrets, staging - s3://og-staging-k8s-secrets, production - s3://og-production-k8s-secrets, production-othv1 - s3://og-production-othv1-k8s-secrets |  `Nil` You must provide your own id    |
| `secrets.usernamePasswordType.deployment-secrets-aws.password`  | Jenkins Kubernetes deployment pipeline Access Key. Must have read only S3 access to the following buckets, across several accounts: test - s3://og-test-k8s-secrets, staging - s3://og-staging-k8s-secrets, production - s3://og-production-k8s-secrets, production-othv1 - s3://og-production-othv1-k8s-secrets    |  `Nil` You must provide your own key    |
| `secrets.usernamePasswordType.operate-aws.username`             | Operate-AWS Access Key ID. User must have `AdministratorAccess` IAM Policy attached |  `Nil` You must provide your own id    |
| `secrets.usernamePasswordType.operate-aws.password`             | Operate-AWS Access Key. User must have `AdministratorAccess` IAM Policy attached |  `Nil` You must provide your own key    |
| `secrets.secretTextType.datadog`                                | Datadog API key  |  `Nil` You must provide your own key    |
| `secrets.secretTextType.deploy-to-fullstack-token` | AUTHENTICATION TOKEN of https://ci.opengov.ninja/job/deploy-to-fullstack  |  `Nil` You must provide your own key    |
| `secrets.secretTextType.deploy-to-ReportApp-token` | AUTHENTICATION TOKEN of https://ci.opengov.ninja/job/deploy-to-integration-ReportApp  |  `Nil` You must provide your own key    |
| `secrets.secretTextType.kubernetes-config-*`                    | Kubernetes cluster credentials used for deployment and automation pipelines; will be used to create a Jenkins secret of type secrettext where its credential ID will be in the form of **"kubernetes-{{clusters-name}}"**. The value must be a kubectl configuration yaml containing the secrets to access the cluster (see the `secrets.example.yaml` file for complete example). Within   |  `[]` You must provide the kubernetes credentials. See description for format.    |
| `secrets.usernamePasswordType.opendata-github.username`                    | Github User to access [OpenGov-OpenData](https://github.com/OpenGov-OpenData) repositories    | `Nil` You must provide your own user |
| `secrets.usernamePasswordType.opendata-github.password`                    | Github User's personal access token to access [OpenGov-OpenData](https://github.com/OpenGov-OpenData) repositories    | `Nil` You must provide your own token |
| `secrets.secretTextType.ja-remote-trigger-token` | Token for external systems, Travis or ci.opengov.com, to trigger [Jenkins Automation](https://github.com/OpenGov/JenkinsAutomation) Pipelines| `Nil` You must profile your own token.

There are also different profiles that customize some of the defaults in the `values.yaml`, these are stored under the [config/](config/) directory.
Currently, we have the following profiles:

- [Minikube](config/minikube.yaml): For local development
- [Staging](config/staging.yaml): For staging environment
- [Production](config/production.yaml): For production environment

### Okta configuration
We currently have 2 Okta applications setup for Jenkins (production, integration), Okta is currently disabled for minikube.

We took these steps to setup:

1. Become Okta Admin and login to Admin Panel
2. Add Application > 'Jenkins SAML'
3. General > Fill out 'Application Label', 'Base URL' should be your Jenkins instance hostname
4. Assignments > Whitelist people who can access this Okta Application
5. Sign On > View Setup Instructions
6. Copy 'IDP Metadata' into `config/${ENVIRONMENT}.yaml` > `.okta.idpMetadata` - Make sure to exclude the first `<xml>` line
7. Copy 'IDP Issuer/Entity ID' into `config/${ENVIRONMENT}.yaml` > `.okta.idpIssuer`

If you're developing on minikube:

8. Set `.okta.enabled` to `true`
9. If developing on minikube, set `.okta.localHostName` and make sure to add entry to your `/etc/hosts` with result from `$(minikube ip)`. If
you changed it from `.okta.localHostName` in `config/minikube.yaml`, make sure to update entry in the Okta application.

If the Jenkins hostname is updated, make sure to repeat Step 3.

## Using Jenkinsci image
### Minikube
After the minikube cluster has been brought up, we need to point to the Docker
daemon running inside the virtual machine so that Kubernetes can deploy
this image:

```bash
eval $(minikube docker-env)

cd helm_charts/jenkinsci # navigate here
```


Then, we can either build the image locally or pull from an existing one.
This will ensure that the image is available on the Kubernetes cluster.

```bash
# Build it locally
docker build --rm -t opengovorg/jenkinsci . # --pull to use latest jenkins:lts image

# Or pull in the latest official image
docker login
docker pull opengovorg/jenkinsci
```

### AWS EKS Kubernetes Cluster
For an AWS Kubernetes cluster, you will need to create the DockerHub registry
secret and attach the secret to the default service account:

```bash
# From within the infrastructure repoisitory
hack/kubernetes_prepare_namespace.sh "${KUBERNETES_CONTEXT}" jenkins enable-rbac
```

## Obtaining Secrets
Ask you friendly EngOps engineer for access.
If you do update the secrets, make sure to re-upload them.

1. Navigate to S3 in EngOps AWS Account
2. Click on the bucket `og-${ENVIRONMENT}-k8s-secrets`
3. Download `jenkins/jenkinsci/secrets.${ENVIRONMENT}.yaml`
4. Securely remove the secrets (`srm`) after your done using them

## Install Jenkinsci
### Minikube
From within the **helm_charts/jenkinsci** directory:

```bash
# Fetch the dependency helm charts
helm dependency update

helm install --namespace jenkins --name jenkins --values secrets.minikube.yaml --values config/minikube.yaml .

# Temporary fix, If you are running the latest minikube ( 0.26 or greater  ) with Kubernetes 1.10
kubectl create clusterrolebinding jenkins --clusterrole cluster-admin --serviceaccount=jenkins:default
```


If you want to add a GitHub repository to monitor then add the **--set "repositories={${REPO_NAME}}"** flag

```bash
REPO_NAME='https://github.com/${USERNAME}/${NAME}.git;${BRANCH_TO_WATCH}'  # e.g. REPO_NAME='https://github.com/Chili-Man/OTH.git;ENGOPS-62'

# Check the resources being created first
helm template --namespace jenkins --name jenkins --values secrets.minikube.yaml --values config/minikube.yaml --set "repositories={${REPO_NAME}}" . | less -S

helm install --namespace jenkins --name jenkins --values secrets.minikube.yaml --values config/minikube.yaml --set "repositories={${REPO_NAME}}" .

```


### AWS EKS
**WARNING** When starting with a fresh EBS volume, you will need to merge in a
new commit to the Voltron and JenkinsAutomation repository so that it triggers
picking up all of the Jenkins pipelines in those repositories

**Caveat** When only upgrading the plugins, you will need to manually kill the
Jenkins master pod in order for it to install the plugin updates. This is a bug
with the underlying Jenkins Helm chart that we use


For production AWS Kubernetes Cluster:

```bash
ENVIRONMENT='[integration | staging | production]'
IMAGE_TAG='latest' # Configure to your liking
helm install . --namespace jenkins --name jenkins --values "secrets.${ENVIRONMENT}.yaml" --values "config/${ENVIRONMENT}.yaml" --set "jenkins.Master.ImageTag=${IMAGE_TAG}"

# For upgrading an existing release
helm diff upgrade jenkins . --namespace jenkins --values "secrets.${ENVIRONMENT}.yaml" --values "config/${ENVIRONMENT}.yaml"
helm upgrade jenkins . --namespace jenkins --recreate-pods --values "secrets.${ENVIRONMENT}.yaml" --values "config/${ENVIRONMENT}.yaml"

# For upgrading an existing release with updated default values and secrets
helm upgrade jenkins . --namespace jenkins --recreate-pods --values values.yaml --values "secrets.${ENVIRONMENT}.yaml" --values "config/${ENVIRONMENT}.yaml"

```

## Logging into the Jenkins Instance
For any Kubernetes cluster, you can get the initial admin password with the following:

```bash
printf $(kubectl get secret --namespace jenkins jenkins-jenkinsci -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode); echo
```

### Minikube
For minikube, you can get the direct URL to the Jenkins server:

```bash
minikube service --namespace=jenkins --url jenkins-jenkinsci
```

### AWS
For accessing it on AWS:

```bash
minikube service --namespace=jenkins --url jenkins-jenkinsci
```

## Artifactory
This chart sets up the following variables which point to our internal Artifactory docker registry:

```bash
INTERNAL_REGISTRY_HOSTNAME=docker-integration.artifactory.opengov.zone
```

We also set a secret which allows push/pull access from Jenkins into the Artifactory Docker registry whose ID
is then exposed via the following envvar:

```bash
INTERNAL_REGISTRY_CREDENTIALS_ID=<id-goes-here>
```

## Gradle Cache
This chart installs a gradle cache container as a stateful set. It is provisioned with its own PVC which is sized
via the `gradle.persistence.size` property. The cache is intended for use by jobs which build using Gradle which
run from INSIDE the cluster only. We expose its location to builds via the following var:

```bash
GRADLE_CACHE_URL=http://{{template "gradle.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local/cache
```

## Service-level Guarentees
### TODO: Update below

- resources vs pricing
    - $146.40/ m4.xlarge (us-west-2)
    - 3 pods per node
        - 1 Jenkins Master/Agent uses 4GB memory and 1 core

- base scale
    - 3 dedicated jenkins nodes (1 per AZ in us-west-2)
    - 9 build slots
    - $900/mo

- max scale
    - 5 dedicated jenkins nodes
    - 15 build slots
    - $732/mo

## Recovery

* Health-check failure on #engops-alerts
    * wait 10 minutes for Jenkins master to recover

* Jenkins master pod is unable to recover
    * `helm del jenkins --purge`
    * Download environment secrets if needed - see previous section on 'Obtains Secrets'
    * `cp secrets.${ENV}.yaml secrets.yaml`
    * `helm install --namespace jenkins --name jenkins --values secrets.yaml --values config/${ENV}.yaml .`

* If the cluster has been re-provisioned, make sure to update the CNAME record in Route53 in EngOps AWS account - `jenkins.engops.opengov.zone`

## Persistent Volumes
We manage PVs outside of the Jenkins Helm chart due to the way the Jenkins Chart deals with existing claims. If you
specify an `ExistingClaim` key in the values.yaml, it will disable the PVC included in the chart. We have an EBS
volume which we created outside of the k8s cluster which we need to attach a PV to via our own templates and
therefore cannot use the included PVCs.

**Note:** if you are starting from scratch you must first create the EBS volume with Terraform or manually before you install the chart. You can then set the `jenkins.Persistence.VolumeId` to the EBS volume you created.

## Notes

- When creating the github machine user personal access token, be sure to include permissions to allow Jenkins to setup webhooks: admin:repo_hook, admin:org_hook, repo
- All pods in the 'jenkins' namespace will be set to resource request and limit to 4G memory and 1 Cpu
- We need datadog api key in `secrets.yaml` for Datadog job event metrics. These can be viewed by going to 'Events' > 'Jenkins', and will show success/failure rate of jobs, as well as avg. time spent running.

## Plugin mismatch in jenkins and plugins are not loading
- When there are errors in manage jenkins and plugins are not loading it means that someone has made manual changes to plugins or dependencies. Even if we try to re-deploy the jenkins helm chart the plugins dont get restored.
- In such cases, login to the jenkins master pod, go to the plugins dir (/var/jenkins_home/plugins)
- copy the plugins.txt from jenkins home to the plugins directory in the pod. (cp ../plugins.txt .)
- verify the versions you are passing are correctly set in this file. compare them with the values in values.yaml
- run the below script to pull those versions


# for i in `cat plugins.txt`
# do
# pluginname=`echo $i|cut -d":" -f1`
# version=`echo $i|cut -d":" -f2`
# wget "https://updates.jenkins-ci.org/download/plugins/$pluginname/$version/$pluginname.hpi" --no-check-certificate
# done

- restart the jenkins after this and force recreate the jenkins master pod.

## Adding admin users in jenkins
- we have seen multiple times people making the changes to jenkins unknowingly, resulting in failed builds and engops time finding out what was changed and reverting that change.
- to avoid this, we have revoked admin rights on all the users except cE and SRE teams.
- To add anyone as an admin please modify values.yaml (.Values.jenkins.master.admins )
- Add the required email to the list and run helm upgrade. The admin user will be added to jenkins
