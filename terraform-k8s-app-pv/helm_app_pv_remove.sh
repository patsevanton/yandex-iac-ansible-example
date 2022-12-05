#!/bin/bash

set -eu pipefail

# uninstall postgresql
echo ""
echo "helm uninstall postgresql"
helm uninstall -n postgresql postgresql || true
kubectl delete namespace postgresql || true
