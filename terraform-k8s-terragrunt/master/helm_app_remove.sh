#!/bin/bash

echo ""

NginxLoadBalancerIP=$(terraform output --raw NginxLoadBalancerIP)
export NginxLoadBalancerIP
echo "================Uninstall other chart======================"
helmfile destroy -f helmfile.yaml
echo "================Destroy Certificate======================"
kubectl delete -f certificate.yaml
echo "================Destroy cert-manager======================"
helmfile destroy -f helmfile-cert-manager.yaml
helmfile destroy -f helmfile-traefik.yaml
helmfile destroy -f helmfile-ingress-nginx.yaml
kubectl delete namespace grafana || true
kubectl delete namespace consul || true
kubectl delete namespace cert-manager || true
kubectl delete namespace ingress-nginx|| true
kubectl delete namespace traefik|| true
