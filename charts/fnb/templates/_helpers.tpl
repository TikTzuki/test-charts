{{/*
Copyright Tiktzuki, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Create the name of the service account to use
*/}}
{{- define "fnb.admin.serviceAccountName" -}}
{{- if .Values.admin.serviceAccount.create }}
{{- default (include "fnb.admin.fullname" .) .Values.admin.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.admin.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return admin name
*/}}
{{- define "fnb.admin.fullname" -}}
    {{- printf "%s-admin" (include "common.names.fullname" .)  | trunc 63 | trimSuffix "-" }}
{{- end -}}
