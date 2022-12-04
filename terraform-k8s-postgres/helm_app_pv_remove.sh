#!/bin/bash

set -eu pipefail

# uninstall Kube-Prometheus-Stack
echo ""
echo "helm uninstall Kube-Prometheus-Stack"
helm uninstall -n postgresql postgresql || true
kubectl delete namespace postgresql || true
