#!/bin/bash

echo ""

cd vpc-address || exit 1
external_ipv4_address=$(terragrunt output --raw external_ipv4_address)
export external_ipv4_address
echo "$external_ipv4_address"
cd ..

helmfile destroy -f helmfile-loggenerator.yaml
helmfile destroy -f helmfile-promtail.yaml
helmfile destroy -f helmfile-loki-distributed.yaml
helmfile destroy -f helmfile-ingress-nginx.yaml
helmfile destroy -f helmfile-kube-prometheus-stack.yaml
kubectl delete namespace monitoring || true
kubectl delete namespace ingress-nginx|| true
rm -f "/home/$USER/.kube/config"
