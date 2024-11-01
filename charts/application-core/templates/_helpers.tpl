{{/*
Expand the name of the chart.
*/}}
{{- define "application-core.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Build the env that gets injected into the containers
If a user provides their own APP_NAME as an environment variable, use it.
Otherwise, use the default APP_NAME which is .Release.Namespace-.Release.Name.
*/}}
{{- define "application-core.env" -}}
{{ .Values.env | toYaml }}
{{- $found := false }}
{{- range .Values.env }}
  {{- if eq .name "APP_NAME" }}
    {{- $found = true }}
  {{- end }}
{{- end }}
{{- if $found }}
{{- else }}
- name: APP_NAME
  value: {{ .Release.Namespace }}-{{ .Release.Name }}
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
