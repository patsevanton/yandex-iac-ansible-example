#!/bin/bash

set -eu pipefail

# uninstall
echo ""
echo "helm uninstall"
helmfile destroy
kubectl delete namespace grafana || true

