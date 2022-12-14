#!/bin/bash

set -eu pipefail

# uninstall Kube-Prometheus-Stack
echo ""
echo "helm uninstall Kube-Prometheus-Stack"
helm uninstall -n loki loki || true
helm uninstall loki || true
helm uninstall kube-prometheus-stack || true
helm uninstall -n kube-prometheus-stack kube-prometheus-stack || true
helm uninstall -n promtail promtail || true
helm uninstall -n loggenerator loggenerator || true
helm uninstall -n cassandra cassandra || true
helm uninstall -n vector vector || true
kubectl delete namespace loki || true
kubectl delete namespace promtail || true
kubectl delete namespace loggenerator || true
kubectl delete namespace cassandra || true
kubectl delete namespace vector || true
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com || true
kubectl delete crd alertmanagers.monitoring.coreos.com || true
kubectl delete crd podmonitors.monitoring.coreos.com || true
kubectl delete crd probes.monitoring.coreos.com || true
kubectl delete crd prometheuses.monitoring.coreos.com || true
kubectl delete crd prometheusrules.monitoring.coreos.com || true
kubectl delete crd servicemonitors.monitoring.coreos.com || true
kubectl delete crd thanosrulers.monitoring.coreos.com || true
