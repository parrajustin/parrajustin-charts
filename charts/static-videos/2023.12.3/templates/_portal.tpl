{{- define "util.portal" -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: list
data:
  path: "/list"
  port: {{ .Values.serviceHttpPort | quote }}
  protocol: http
  host: $node_ip
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: counters
data:
  path: "/counters"
  port: {{ .Values.serviceHttpPort | quote }}
  protocol: http
  host: $node_ip
{{- end -}}