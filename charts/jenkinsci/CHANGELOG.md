# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [1.X.Y] - UNRELEASED
## [1.49.5] - 2022-08-12
### Changed
- Update Isodoro version to 1.0.1 to inherit the remaining 2022 release dates.

## [1.49.4] - 2022-07-11
- Helm remove deprecated APIs to support k8s version 1.22+ [commit-1](https://github.com/OpenGov/infrastructure/commit/8f3fe7cbaecd836db1309830db8d738dcfb3190f) [commit-2](https://github.com/OpenGov/infrastructure/commit/c241ad753f32d36e4aaaa4e3f6f33ad3168a5cf9)

## [1.41.0] - 2020-09-10
### Added
- Installed generic-webhook-trigger plugin 2.7.4

### Changed
- Change Jenkins Java garbage collection to official recommendations from https://jenkins.io/blog/2016/11/21/gc-tuning/ (setting as is for some reason causes jenkins to crash, might need to also adjust heap sizes)
- Upgraded Jenkins 2.222.3 -> 2.249.1 (Docker tag 2.249.1-lts-centos7)
- Upgraded all plugins

## [1.40.0] - 2020-09-02
### Added
- Added PLC DEV and FINANCIAL INT Accounts

## [1.39.0] - 2020-05-05
### Added
- Added new terratest secret

## [1.38.0] - 2020-04-30
### Added
- Added bitbucket external webhook

## [1.37.0] - 2020-04-29
### Added
- Added required Slack integration secrets

## [1.36.0] - 2020-04-29
### Changed
- Upgraded Jenkins 2.222.1 -> 2.222.3 which fixes global discarder tool configuration persistence issues
- Updated all plugins to latest versions

## [1.35.0] - 2020-04-11
### Changed
- Upgraded Jenkins 2.204.2 -> 2.222.1 (security fixes: https://jenkins.io/security/advisory/2020-03-25/)
- Update Jenkins JLNP slave to the latest version for websocket support
- Updated all plugins to latest versions

## [1.34.0] - 2020-03-23
### Changed
- Updated script approvals in anticipation for supporting the Isodoro dispacther pipelines
- Updated all plugins to latest versions

## [1.33.0] - 2020-02-18
### Changed
- Tune `Deployment` ulimits to prevent `java.lang.OutOfMemoryError: unable to create new native thread`
- Updated all plugins to latest versions

### Removed
- Removed ReportApp and FileParserAPI since they are deprecated repositories

## [1.32.0] - 2020-02-05
### Changed
- Upgraded Jenkins 2.204.1 -> 2.204.2 (security fixes: https://jenkins.io/security/advisory/2020-01-29/)
- Updated all plugins to latest versions

## [1.31.0] - 2019-12-23
### Changed
- Updated jenkins example secrets to include Artifactory NPM credentials
- Upgraded Jenkins 2.190.3 -> 2.204.1
- Updated all plugins to latest versions

## [1.30.0] - 2019-12-13
### Changed
- Upgraded to Jenkins 2.190.3 from 2.190.2
- Updated all plugins to latest versions

## [1.29.0] - 2019-11-21
### Added
- Artifactory plugin

## [1.28.0] - 2019-11-15
### Changed
- Upgraded plugins to latest versions

## [1.27.0] - 2019-11-13
### Changed
- Upgraded plugins to latest versions

## [1.26.0] - 2019-11-12
### Changed
- Upgraded plugins to latest versions

## [1.25.0] - 2019-11-07
### Changed
- Added another script approval required for CI/CD v2 pipelines
- Upgraded plugins to latest versions

## [1.24.0] - 2019-11-01
### Changed
- Upgraded to Jenkins 2.190.2 from 2.190.1

### Added
- Added some more script approvals required for CI/CD v2 pipelines

## [1.23.0] - 2019-10-25
### Changed
- Upgraded to Jenkins 2.190.2 from 2.190.1

## [1.22.0] - 2019-10-25
### Changed
- Updated IDP issuer field because Okta changed the URL

### Added
- More script approvals required by the Isodoro library

### Changed
- Upgraded all Jenkins plugins to their latest versions

## [1.21.0] - 2019-10-14
### Changed
- Upgraded all Jenkins plugins to their latest versions

## [1.20.0] - 2019-10-10
### Changed
- Upgraded all Jenkins plugins to their latest versions

### Added
- AWS credentials for EKS read access in support of CI/CD v2 workflow automation
- Added more methods that should be approved by Jenkins

## [1.19.0] - 2019-09-04
### Changed
- Upgraded to Jenkins 2.190.1 from 2.176.3 (Security fixes for https://jenkins.io/security/advisory/2019-09-25/ and https://jenkins.io/security/advisory/2019-08-28/)
- Upgraded all Jenkins plugins to their latest versions; in particular the Kubernetes plugin was updated to version 1.19.1 which should increase pod provisioning speed.

### Added
- Opsgenie secret

### Removed
- Deprecated kubernetes config secrets as they were only valid for kops clusters
- Unused Kubernetes-pipeline plugin

## [1.18.0] - 2019-09-04
### Changed
- Updated Jenkins BlueOcean to 1.19 to address UI issues, https://issues.jenkins-ci.org/browse/JENKINS-58085

## [1.17.0] - 2019-08-28
### Added
- Added Isodoro as a default Jenkins library
- Added more credentials to the secrets example for compatibility with Isodoro Jenkins library

### Changed
- Upgraded to Jenkins 2.176.3 from 2.176.2 (Security fixes)
- Upgraded Jenkins kubernetes plugin to 1.18.3
- Updated Jenkins plugins to latest version

## [1.16.0] - 2019-06-18
### Changed
- Upgraded to Jenkins 2.176.2 from 2.164.3; Although Docker image says it was on 2.181, we never deployed that version as we had reverted to 2.164.3; see changelog entry for 1.15.0
- Upgraded Jenkins kubernetes plugin to 1.16.7
- Increase resources CPU and memory for Jenkins as it was resulting in OOM
- Added workspace-cleanup plugin for cleaning up the workspace before builds
- Completed the list examples required for production
- Refactored credentials [initilization script](scripts/initCredentials.groovy) and add support for SSH keys

## [1.15.0] - 2019-06-18
### Changed
- Downgraded to Jenkins 2.164.3 from 2.181 because of issues with Kubernetes
- Upgraded Jenkins kubernetes plugin to 1.16.1
- Increased Kubernetes connection timeout
- Increased CPU requests as Jenkins CPU was getting throttled

## [1.14.0] - 2019-06-18
### Changed
- Increased Kubernetes connection timeout to, see details of issue here https://issues.jenkins-ci.org/browse/JENKINS-56939?page=com.atlassian.streams.streams-jira-plugin%3Aactivity-stream-issue-tab
- Updated Jenkins image to 2.181 which should also help resolve some of the Kubernetes connection issues we have been seeing, see https://issues.jenkins-ci.org/browse/JENKINS-55945
- Updated plugins to latest versions

### Added
- Add more script approvals

## [1.13.0] - 2019-06-13
### Changed
- Upgraded to Jenkins 2.176.1 from 2.164.3
- Upgraded all Jenkins plugins to latest versions
- Added plugin `build-blocker-plugin` for stopping jobs from running if other pipelines are running

## [1.12.0] - 2019-06-04
### Changed
- Increased ping timeout for pod connections from the default 1000ms to 60000ms (60s) as recommended by https://issues.jenkins-ci.org/browse/JENKINS-53532
- Update plugins to latest versions
- Update default agent image to use alpine version to match with the OGJenkins library

## [1.11.1] - 2019-05-30
### Changed
- Update default image tag to use Jenkins 2.164.3
- Update default agent image to 3.29

## [1.11.0] - 2019-05-23
### Changed
- Upgraded Jenkins to 2.164.3 from 2.150.3
- Updated Jenkinsfile to use latest version of OGJenkinsLib
- Update spotify-docker-gc helm chart to 1.0.0; no actual changes, just promoted to stable v1.0.0
- Fixed Helm lint issues

## [1.10.1] - 2019-05-06
### Changed
- Corrected spelling mistakes

## [1.10.0] - 2019-05-07
### Changed
- Setting the Kubernetes Max API connections to 64

## [1.9.0] - 2019-05-06
### Changed
- Add sendGrid and OpenGov platform credentials to Jenkins

## [1.8.0] - 2019-04-07
### Changed
- Updated Jenkins endpoint in production environment to run behind VPN


## [1.7.0] - 2019-03-19
### Changed
- Jenkins Internal Ingress added
- IDp metadata for Okta integration updated for Jenkins in integration environment

## [Unreleased]
## [1.6.0] - 2019-02-16
### Changed
- Updated Jenkins server version to be pinned down to LTS release (2.150.3)
- Updated Jenkins plugins to latest versions, in particular updates Kubernetes plugin (1.14.4) to fix [client memory leak](https://github.com/jenkinsci/kubernetes-plugin/blob/master/CHANGELOG.md#1136)

## [1.5.1] - 2019-02-01
### Changed
- Updated the `secrets.example.yaml` file to include credentials for OTH integration tests

## [1.5.0] - 2018-12-11
### Changed
- updated Jenkins memory req/lim to 14G

## [1.4.2] - 2018-12-03
### Changed
- Updated the `secrets.example.yaml` file to include the kubernetes-deployment pipeline secrets for EKS

## [1.4.1] - 2018-11-26
### Fixed
- set JAVA_OPTS to memory request - 2G to make space for rest of address space

## [1.4.0] - 2018-11-21
### Added
- New production helm values for the EKS clusters
- Updated Jenkins version to 2.152
- Updated Jenkins Plugins to latest versions

## [1.3.0] - 2018-11-19
### Added
- added docker registry hostname base

## [1.2.0] - 2018-11-16
### Added
- Support for new Integration environment

### Changed
- Updated Jenkins Plugins to latest versions
- Updated Jenkins version to 2.151

## [1.1.0] - 2018-11-13
### Added
- Added `spotify-docker-gc` Helm chart to manage storage issues from direct Docker builds on the Kubernetes clusters

### Changed
- Updated change log format to [Keep a Changelog](http://keepachangelog.com/) style
- Updated pvc storage class to reflect new name

## [1.0.0] - 2018-11-12
### Changed
- Enable RBAC support

## [0.21.0] - 2010-11-08
### Changed
- bumped Jenkins Master memory request and limit to 12G
- added '-XX:+UseG1GC' to JAVA_OPTS for Jenkins Master

## [0.20.0] - 2010-11-03
### Added
- Added Gradle cache stateful set
- Added new Jenkins envvar `GRADLE_CACHE_URL`
- Added new Jenkins envvar `INTERNAL_MAVEN_URL` - points to the Maven url for the given env
- Added new Jenkins envvar `INTERNAL_MAVEN_CREDENTIALS_ID` - points to creds to use for maven
- Added `gradle-cache` as chart dependency

## [0.19.0] - 2010-11-01
### Added
- do not create seed jobs (v1) on init
- added missing part to plugin script in values.yaml
- updated Jenkins to v2.149
- remove label plugin from Dockerfile
- updated plugins

## [0.18.0] - 2010-10-31
### Changed
- bumped up number of executors on Jenkins master to 10

## [0.17.0] - 2010-10-30
### Changed
- Bumping plugin versions to latest
- Setting UI timezone to Los_Angeles
