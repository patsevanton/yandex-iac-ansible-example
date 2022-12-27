#!/bin/bash

set -eu pipefail

echo ""
echo "helm uninstall harbor"
helm uninstall -n harbor harbor || true
kubectl delete namespace harbor || true
