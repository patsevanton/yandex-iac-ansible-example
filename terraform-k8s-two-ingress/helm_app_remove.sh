#!/bin/bash

echo ""
echo "helm uninstall"
kubectl delete -f certificate.yaml
helmfile destroy
kubectl delete namespace grafana || true
