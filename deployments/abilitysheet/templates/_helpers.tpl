{{- define "abilitysheet.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "abilitysheet.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "abilitysheet.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "abilitysheet.puma.name" -}}
{{- include "abilitysheet.fullname" . -}}-puma
{{- end -}}}}

{{- define "abilitysheet.sidekiq.name" -}}
{{- include "abilitysheet.fullname" . -}}-sidekiq
{{- end -}}}}

{{- define "abilitysheet.rails-env.name" -}}
{{- include "abilitysheet.fullname" . -}}-rails-env
{{- end -}}}}

{{- define "abilitysheet.pg.name" -}}
{{- include "abilitysheet.fullname" . -}}-pg
{{- end -}}}}

{{- define "abilitysheet.redis.name" -}}
{{- include "abilitysheet.fullname" . -}}-redis
{{- end -}}}}
