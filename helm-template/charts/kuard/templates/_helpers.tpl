{{- define "kuard.selectorLabels" -}}
app.kubernetes.io/name: kuard
app.helm.sh/release: "{{ .Release.Name }}"
{{- end -}}

{{- define "kuard.metadataLabels" -}}
{{ include "kuard.selectorLabels" $ }}
app.helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
app.skaffold.dev/artifact: "{{ regexReplaceAll "[\\W]" .Values.image.repository "_" | trunc 63 | trimAll "_" }}"
app.skaffold.dev/tag: "{{ regexReplaceAll "[\\W]" .Values.image.tag "_" | trunc 63 | trimAll "_" }}"
{{- end -}}

{{- define "kuard.configsChecksum" -}}
{{- list .Values.configEnvs .Values.secretConfigEnvs .Values.configFiles .Values.secretConfigFiles | toJson | sha256sum -}}
{{- end -}}
