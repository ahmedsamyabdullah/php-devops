{{- define "php-devops.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "php-devops.fullname" -}}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "php-devops.labels" -}}
app.kubernetes.io/name: {{ include "php-devops.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
