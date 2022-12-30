#!/bin/bash

set -eu pipefail

echo ""
echo "helm uninstall sentry"
helm uninstall -n sentry sentry || true
kubectl delete namespace sentry || true
helm uninstall -n cert-manager cert-manager || true
kubectl delete namespace cert-manager || true
