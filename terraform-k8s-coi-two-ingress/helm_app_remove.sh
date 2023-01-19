#!/bin/bash

echo ""

export NginxLoadBalancerIP=$(terraform output --raw NginxLoadBalancerIP)
export TraefikLoadBalancerIP=$(terraform output --raw TraefikLoadBalancerIP)
echo "================Uninstall other chart======================"
helmfile destroy -f helmfile.yaml
echo "================Destroy Certificate======================"
kubectl delete -f certificate.yaml
echo "================Destroy cert-manager======================"
helmfile destroy -f helmfile-cert-manager.yaml
kubectl delete namespace grafana || true
kubectl delete namespace consul || true
kubectl delete namespace cert-manager || true
