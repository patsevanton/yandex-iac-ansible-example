#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

echo ""
export NginxLoadBalancerIP=$(terraform output --raw NginxLoadBalancerIP)
export TraefikLoadBalancerIP=$(terraform output --raw TraefikLoadBalancerIP)
echo "================Install cert-manager======================"
kubectl create namespace grafana || true
kubectl create namespace consul || true
helmfile apply -f helmfile-cert-manager.yaml
echo "================Create Certificate======================"
kubectl apply -f certificate.yaml
echo "================Install Other chart======================"
helmfile apply -f helmfile.yaml


end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
