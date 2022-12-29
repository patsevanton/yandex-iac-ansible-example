#!/bin/bash

set -eu pipefail

echo ""
echo "helm uninstall nexus"
helm uninstall -n nexus nexus || true
kubectl delete namespace nexus || true
