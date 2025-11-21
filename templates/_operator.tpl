{{/*
OLM Operator template that creates Namespace, OperatorGroup, and Subscription resources.
Usage:
  {{- include "olm.operator" (dict "namespace" "my-operator" "name" "my-operator-name" "channel" "stable" "source" "redhat-operators" "sourceNamespace" "openshift-marketplace" "installPlanApproval" "Automatic") -}}

Parameters:
  - namespace: The namespace where the operator will be installed (required)
  - name: The name of the operator subscription (required)
  - channel: The subscription channel (required)
  - source: The catalog source (default: "redhat-operators")
  - sourceNamespace: The namespace of the catalog source (default: "openshift-marketplace")
  - installPlanApproval: Installation approval mode (default: "Automatic")
  - operatorGroupName: The name of the OperatorGroup (default: same as namespace)
*/}}
{{- define "olm.operator" -}}
{{- $namespace := required "namespace is required" .namespace -}}
{{- $name := required "name is required" .name -}}
{{- $channel := required "channel is required" .channel -}}
{{- $source := default "redhat-operators" .source -}}
{{- $sourceNamespace := default "openshift-marketplace" .sourceNamespace -}}
{{- $installPlanApproval := default "Automatic" .installPlanApproval -}}
{{- $operatorGroupName := default $namespace .operatorGroupName -}}
apiVersion: v1
kind: Namespace
metadata:
  name: {{ $namespace }}
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: {{ $operatorGroupName }}
  namespace: {{ $namespace }}
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: {{ $name }}
  namespace: {{ $namespace }}
spec:
  channel: {{ $channel }}
  installPlanApproval: {{ $installPlanApproval }}
  name: {{ $name }}
  source: {{ $source }}
  sourceNamespace: {{ $sourceNamespace }}
{{- end -}}
