{{- define "util.portal" -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: portal
data:
  path: "/"
  port: {{ .Values.serviceHttpPort | quote }}
  protocol: http
  host: $node_ip
{{- end -}}