#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

echo "================Install ingress-nginx======================"
helmfile apply -f helmfile-ingress-nginx.yaml
echo sleep 5
sleep 5
echo "================ Install cert-manager ======================"
helmfile apply -f helmfile-cert-manager.yaml
echo sleep 5
sleep 5
echo "================ Create ClusterIssuer ======================"
kubectl apply -f ClusterIssuer.yaml
echo sleep 5
sleep 5
echo "================ Install kube-prometheus-stack ======================"
helmfile apply -f helmfile-kube-prometheus-stack.yaml


end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
