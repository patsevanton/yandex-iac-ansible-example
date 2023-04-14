#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
kubectl create namespace istio-system  || true
helm install istio-base istio/base -n istio-system --version 1.17.2
helm install istiod istio/istiod -n istio-system --version 1.17.2
export Promgrafana_LoadBalancerIP=$(terraform output --raw Promgrafana_LoadBalancerIP)
helm install istio-ingressgateway -n istio-system istio/gateway --version 1.17.2 --set service.loadBalancerIP="$Promgrafana_LoadBalancerIP"

helm install -n istio-system --set auth.strategy="anonymous" \
  --repo https://kiali.org/helm-charts \
  kiali-server kiali-server

echo ""
echo "Install Kube-Prometheus-Stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#helm repo update
kubectl create namespace prometheus || true
helm upgrade --install --wait -n prometheus kube-prometheus-stack prometheus-community/kube-prometheus-stack

end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
