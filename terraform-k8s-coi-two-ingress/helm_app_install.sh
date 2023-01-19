#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

echo ""
NginxLoadBalancerIP=$(terraform output --raw NginxLoadBalancerIP)
export NginxLoadBalancerIP
TraefikLoadBalancerIP=$(terraform output --raw TraefikLoadBalancerIP)
export TraefikLoadBalancerIP
echo "================ create namespace ======================"
kubectl create namespace grafana || true
kubectl create namespace consul || true
echo "================Install ingress-nginx======================"
helmfile apply -f helmfile-ingress-nginx.yaml
echo sleep 10
sleep 10
echo "================ Install traefik ======================"
helmfile apply -f helmfile-traefik.yaml
echo sleep 10
sleep 10
echo "================ Install cert-manager ======================"
helmfile apply -f helmfile-cert-manager.yaml
echo sleep 10
sleep 10
echo "================ Create Certificate ======================"
kubectl apply -f certificate.yaml
echo sleep 10
sleep 10
echo "================ Install Other chart ======================"
helmfile apply -f helmfile.yaml


end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
