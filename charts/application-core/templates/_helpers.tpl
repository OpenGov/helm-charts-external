{{/*
Expand the name of the chart.
*/}}
{{- define "application-core.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Build the short stage name based off of the namespace
*/}}
{{- define "application-core.shortStage" }}
{{- if contains "-production" .Release.Namespace }}
{{- printf "%s" "prd" }}
{{- else if contains "-performance" .Release.Namespace }}
{{- printf "%s" "perf" }}
{{- else if contains "-integration" .Release.Namespace }}
{{- printf "%s" "int" }}
{{- else if contains "-sandbox" .Release.Namespace }}
{{- printf "%s" "sbx" }}
{{- else if contains "-staging" .Release.Namespace }}
{{- printf "%s" "stg" }}
{{- else if contains "-demo" .Release.Namespace }}
{{- printf "%s" "demo" }}
{{- else if contains "-qa" .Release.Namespace }}
{{- printf "%s" "qa" }}
{{- else if contains "-development" .Release.Namespace }}
{{- printf "%s" "dev" }}
{{- else }}
{{- printf "%s" .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Build the env that gets injected into the deployments
*/}}
{{- define "application-core.env" -}}
- name: APP_NAME
  value: {{ .Values.appName | default (printf "%s-%s" .Release.Name (include "application-core.shortStage" . )) }}
{{- if .Values.env }}
{{ .Values.env | toYaml }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "application-core.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "application-core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "application-core.labels" -}}
helm.sh/chart: {{ include "application-core.chart" . }}
{{ include "application-core.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "application-core.annotations" -}}
service: {{ include "application-core.fullname" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "application-core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "application-core.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "application-core.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "application-core.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Build the Env vars that get sent to github-deployment-hook
*/}}
{{- define "application-core.github-deployment-hook.env" }}
- name: ENVIRONMENT_URL
  valueFrom:
    configMapKeyRef:
      name: {{ .Values.githubDeploymentHook.configMapName }}
      key: {{ .Values.githubDeploymentHook.envUrlKey }}
- name: LOG_URL
  valueFrom:
    configMapKeyRef:
      name: {{ .Values.githubDeploymentHook.configMapName }}
      key: {{ .Values.githubDeploymentHook.logUrlKey }}
- name: ENVIRONMENT_NAME
  valueFrom:
    configMapKeyRef:
      name: {{ .Values.githubDeploymentHook.configMapName }}
      key: {{ .Values.githubDeploymentHook.environmentNameKey }}
- name: GITHUB_REF
  valueFrom:
    configMapKeyRef:
      name: {{ .Values.githubDeploymentHook.configMapName }}
      key: {{ .Values.githubDeploymentHook.githubRefKey }}
- name: GITHUB_REPO
  value: {{ .Values.githubDeploymentHook.githubRepo }}
- name: GITHUB_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ .Values.githubDeploymentHook.secretName }}
      key: {{ .Values.githubDeploymentHook.githubTokenSecretKey }}
{{- end }}