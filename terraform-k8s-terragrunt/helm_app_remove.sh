#!/bin/bash

echo ""

cd vpc-address
export external_ipv4_address=$(terragrunt output --raw external_ipv4_address)
echo "$external_ipv4_address"
cd ..

helmfile destroy -f helmfile-ingress-nginx.yaml
helmfile destroy -f helmfile-kube-prometheus-stack.yaml
kubectl delete namespace monitoring || true
kubectl delete namespace ingress-nginx|| true

