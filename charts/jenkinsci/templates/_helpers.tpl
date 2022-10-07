{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jenkinsci.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "jenkinsci.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified Gradle cache app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gradle.fullname" -}}
{{- $name := default .Values.gradle.name .Values.gradle.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "jenkinsci.github-version" -}}
  {{- range .Values.jenkins.master.installPlugins -}}
    {{ if hasPrefix "github:" . }}
      {{- $split := splitList ":" . }}
      {{- printf "%s" (index $split 1 ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "jenkinsci.kubernetes-version" -}}
  {{- range .Values.jenkins.master.installPlugins -}}
    {{ if hasPrefix "kubernetes:" . }}
      {{- $split := splitList ":" . }}
      {{- printf "%s" (index $split 1 ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
 We define this empty function to fullfill the jenkins chart contract for
 creating a config map for Jenkins. We create the entire thing in
 templates/config.yaml because the jenkins chart one doesn't work with
 importing files from this chart
*/}}
{{- define "override_config_map" }}
{{- end -}}
