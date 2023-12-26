{{/* Service Class */}}
{{/* Call this template:
{{ include "ix.v1.common.class.service" (dict "rootCtx" $ "objectData" $objectData) }}

rootCtx: The root context of the chart.
objectData: The service data, that will be used to render the Service object.
*/}}

{{- define "ix.v1.common.class.service" -}}

  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}

  {{- $svcType := $objectData.type | default $rootCtx.Values.fallbackDefaults.serviceType -}}

  {{/* Init variables */}}
  {{- $hasHostPort := $rootCtx.Values.hostNetwork -}}

  {{/* When hostPort is defined, force ClusterIP aswell */}}
  {{- if $hasHostPort -}}
    {{- $svcType = "ClusterIP" -}}
  {{- end -}}
  {{- $_ := set $objectData "type" $svcType }}

---
apiVersion: v1
kind: Service
metadata:
  name: {{ $objectData.name }}
  {{- $labels := (mustMerge ($objectData.labels | default dict) (include "ix.v1.common.lib.metadata.allLabels" $rootCtx | fromYaml)
                            (include "ix.v1.common.lib.metadata.selectorLabels" (dict "rootCtx" $rootCtx "objectType" "service" "objectName" $objectData.shortName) | fromYaml)) -}}
  {{- with (include "ix.v1.common.lib.metadata.render" (dict "rootCtx" $rootCtx "labels" $labels) | trim) }}
  labels:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- $annotations := (mustMerge ($objectData.annotations | default dict) (include "ix.v1.common.lib.metadata.allAnnotations" $rootCtx | fromYaml)) -}}
  {{- with (include "ix.v1.common.lib.metadata.render" (dict "rootCtx" $rootCtx "annotations" $annotations) | trim) }}
  annotations:
    {{- . | nindent 4 }}
  {{- end }}
spec:
  {{- if eq $objectData.type "ClusterIP" -}}
    {{- include "ix.v1.common.lib.service.spec.clusterIP" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 2 -}}
  {{- else if eq $objectData.type "NodePort" -}}
    {{- include "ix.v1.common.lib.service.spec.nodePort" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 2 -}}
  {{- end -}}
  {{- with (include "ix.v1.common.lib.service.ports" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
  ports:
    {{- . | nindent 4 }}
  {{- end }}
  selector:
    app.kubernetes.io/name: {{ $rootCtx.Release.Name }}
{{- end -}}