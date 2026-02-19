{{/*
Expand the name of the chart.
*/}}
{{- define "og-application.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Build the short stage name based off of the namespace
*/}}
{{- define "og-application.shortStage" }}
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
{{- define "og-application.env" -}}
- name: APP_NAME
  value: {{ .Values.appName | default (printf "%s-%s" .Release.Name (include "og-application.shortStage" . )) }}
{{- if .Values.env }}
{{ .Values.env | toYaml }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "og-application.fullname" -}}
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
{{- define "og-application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels (include namespace label; applied to all manifests)
*/}}
{{- define "og-application.labels" -}}
helm.sh/chart: {{ include "og-application.chart" . }}
{{ include "og-application.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
namespace: {{ .Release.Namespace }}
{{- with .Values.commonLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "og-application.annotations" -}}
service: {{ include "og-application.fullname" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "og-application.selectorLabels" -}}
app.kubernetes.io/name: {{ include "og-application.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "og-application.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "og-application.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

