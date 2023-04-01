#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

echo ""
echo "Install Kube-Prometheus-Stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#helm repo update
kubectl create namespace prometheus || true
helm upgrade --install --wait -n prometheus kube-prometheus-stack prometheus-community/kube-prometheus-stack -f values-kube-prometheus-stack.yaml

#echo ""
#echo "Install redis"
#helm repo add archive-full-bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
##helm repo update
#kubectl create namespace redis || true
#helm upgrade --install --wait -n redis redis archive-full-bitnami/redis --version 17.4.2 -f values-redis.yaml

end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
