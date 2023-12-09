{{/*
Copyright Tiktzuki, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper image name
*/}}
{{- define "fnb.admin.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.admin.image "global" .Values.global) }}
{{- end -}}
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
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "fnb.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.admin.image .Values.volumePermissions.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Return admin name
*/}}
{{- define "fnb.admin.fullname" -}}
    {{- printf "%s-admin" (include "common.names.fullname" .)  | trunc 63 | trimSuffix "-" }}
{{- end -}}
