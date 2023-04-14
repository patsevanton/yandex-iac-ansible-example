#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
kubectl create namespace istio-system  || true
helm upgrade --install --wait istio-base istio/base -n istio-system --version 1.17.2
helm upgrade --install --wait istiod istio/istiod -n istio-system --version 1.17.2
export Promgrafana_LoadBalancerIP=$(terraform output --raw Promgrafana_LoadBalancerIP)
helm upgrade --install --wait istio-ingressgateway -n istio-system istio/gateway --version 1.17.2 --set service.loadBalancerIP="$Promgrafana_LoadBalancerIP"

helm upgrade --install --wait -n istio-system --set auth.strategy="anonymous" \
  --repo https://kiali.org/helm-charts \
  kiali-server kiali-server

echo ""
echo "Install Kube-Prometheus-Stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#helm repo update
kubectl create namespace prometheus || true
kubectl label namespace prometheus istio-injection=enabled
helm upgrade --install --wait -n prometheus kube-prometheus-stack prometheus-community/kube-prometheus-stack

kubectl apply -f gateway-grafana.yaml
kubectl apply -f virtualservice-grafana.yaml

end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
