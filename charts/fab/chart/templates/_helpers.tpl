{{/*
Expand the name of the chart.
*/}}
{{- define "rd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rd.fullname" -}}
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
{{- define "rd.chart" -}}
{{- if .Values.fullnameOverride }}
{{- printf "%s-%s" .Values.fullnameOverride .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rd.labels" -}}
helm.sh/chart: {{ include "rd.chart" . }}
{{ include "rd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Create Deployment define *Port*
*/}}
{{- define "rd.deployment.ports" -}}
{{- range $value :=  .Values.deployment.ports }}
- name: {{ $value.name }}
  containerPort: {{ $value.containerPort }}
  protocol: {{ $value.protocol }}
{{- end }}
{{- end }}

{{/*
Create Service Ports for any type "ClusterIP" and "NodePort"
*/}}
{{- define "rd.service.ports" -}}
{{- if eq .Values.service.type "ClusterIP" }}
{{- range $value :=  .Values.service.ports }}
- port: {{ $value.port }}
  targetPort: {{ $value.targetPort }}
  protocol: {{ $value.protocol }}
  name: {{ $value.name }}
{{- end }}
{{- end }}
{{- if eq .Values.service.type "NodePort"  }}
{{- range $value :=  .Values.service.ports }}
- port: {{ $value.port }}
  nodePort: {{ $value.nodePort }}
  targetPort: {{ $value.targetPort }}
  protocol: {{ $value.protocol }}
  name: {{ $value.name }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create env define *Env*
*/}}
{{- define "rd.env.key_value" -}}
{{- range $key , $value :=  .Values.env.key_value }}
- name: {{ $key }}
  value: "{{ $value }}"
{{- end }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "rd.names.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
