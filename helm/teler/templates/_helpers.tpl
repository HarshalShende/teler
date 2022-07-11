{{/*
Expand the name of the chart.
*/}}
{{- define "teler.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "teler.fullname" -}}
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
{{- define "teler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "teler.labels" -}}
helm.sh/chart: {{ include "teler.chart" . }}
{{ include "teler.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "teler.selectorLabels" -}}
app.kubernetes.io/name: {{ include "teler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "teler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "teler.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
teler default configuration
*/}}
{{- define "teler.defaultConfig" -}}
# To write log format, see https://www.notion.so/kitabisa/Configuration-d7c8fab40366406591875bac631bef3f
log_format: |
  $remote_addr $remote_user - [$time_local] "$request_method $request_uri $request_protocol" 
  $status $body_bytes_sent "$http_referer" "$http_user_agent"

rules:
  cache: true
  threat:
    excludes:
      # - "Common Web Attack"
      # - "CVE"
      # - "Bad IP Address"
      # - "Bad Referrer"
      # - "Bad Crawler"
      # - "Directory Bruteforce"

    # It can be user-agent, request path, HTTP referrer,
    # IP address and/or request query values parsed in regExp. 
    # This list applies only to engine defined threats, not to custom threat rules.
    whitelists:
      # - (curl|Go-http-client|okhttp)/*
      # - ^/wp-login\.php
      # - https?:\/\/www\.facebook\.com
      # - 192\.168\.0\.1

    customs:
      # - name: "Log4j Attack"
      #   condition: or
      #   rules:
      #     - element: "request_uri"
      #       pattern: \$\{.*:\/\/.*\/?\w+?\}

      #     - element: "http_referer"
      #       pattern: \$\{.*:\/\/.*\/?\w+?\}

      #     - element: "http_user_agent"
      #       pattern: \$\{.*:\/\/.*\/?\w+?\}

      # - name: "Large File Upload"
      #   condition: and
      #   rules:
      #     - element: "body_bytes_sent"
      #       selector: true
      #       pattern: \d{6,}

      #     - element: "request_method"
      #       pattern: P(OST|UT)

dashboard:
  active: true
  host: "localhost"
  port: 9080
  username: "wew"
  password: "w0w!"
  endpoint: "/events"
  
metrics:
  prometheus:
    active: false
    host: "localhost"
    port: 9099
    endpoint: "/metrics"

logs:
  file:
    active: false
    json: false
    path: "/path/to/output.log"

  zinc:
    active: false
    host: "localhost"
    port: 4080
    ssl: false
    username: "admin"
    password: "Complexpass#123"
    index: "lorem-ipsum-index"

alert:
  active: false
  provider: "slack"

notifications:
  # Only Slack & Discord that can post alerts via webhook,
  # meaning that if the webhook field is filled & valid in
  # it'll use the given webhook URL, otherwise it will use
  # token to authenticate.

  slack:
    webhook: "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
    token: "xoxo-...."
    color: "#ffd21a"
    channel: "G30SPKI"

  telegram:
    token: "123456:ABC-DEF1234...-..."
    chat_id: "-111000"

  discord:
    webhook: "https://discord.com/api/webhooks/0000000000/XXXXX"
    token: "NkWkawkawkawkawka.X0xo.n-kmZwA8aWAA"
    color: "16312092"
    channel: "700000000000000..."

  mattermost:
    webhook: "http://HOST/hooks/XXXXX-KEY-XXXXX"
    color: "#ffd21a"
{{- end }}

{{/*
teler configuration mount path
*/}}
{{- define "teler.configMount" -}}
{{ print "/etc/teler/config.yaml" }}
{{- end }}