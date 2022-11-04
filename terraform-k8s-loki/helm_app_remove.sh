#!/bin/bash

set -eu pipefail

# uninstall Kube-Prometheus-Stack
echo ""
echo "helm uninstall Kube-Prometheus-Stack"
helm uninstall loki || true
helm uninstall promgrafana || true
helm uninstall promtail || true
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com || true
kubectl delete crd alertmanagers.monitoring.coreos.com || true
kubectl delete crd podmonitors.monitoring.coreos.com || true
kubectl delete crd probes.monitoring.coreos.com || true
kubectl delete crd prometheuses.monitoring.coreos.com || true
kubectl delete crd prometheusrules.monitoring.coreos.com || true
kubectl delete crd servicemonitors.monitoring.coreos.com || true
kubectl delete crd thanosrulers.monitoring.coreos.com || true
