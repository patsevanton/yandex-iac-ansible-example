#!/bin/bash

set -eu pipefail

# uninstall Kube-Prometheus-Stack
echo ""
echo "helm uninstall Kube-Prometheus-Stack"
helm uninstall -n redis redis || true
helm uninstall -n kube-prometheus-stack kube-prometheus-stack || true
helm uninstall -n prometheus kube-prometheus-stack || true
kubectl delete namespace redis || true
kubectl delete namespace kube-prometheus-stack || true
kubectl delete namespace prometheus || true
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com || true
kubectl delete crd alertmanagers.monitoring.coreos.com || true
kubectl delete crd podmonitors.monitoring.coreos.com || true
kubectl delete crd probes.monitoring.coreos.com || true
kubectl delete crd prometheuses.monitoring.coreos.com || true
kubectl delete crd prometheusrules.monitoring.coreos.com || true
kubectl delete crd servicemonitors.monitoring.coreos.com || true
kubectl delete crd thanosrulers.monitoring.coreos.com || true
