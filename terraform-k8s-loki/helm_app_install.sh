#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

#echo ""
#echo "refresh helm cache"
#rm -rf ~/.helm/cache/archive/*
#rm -rf ~/.helm/repository/cache/*

# Установка cert-manager
echo ""
echo "Install cert-manager:"
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true --debug

echo ""
echo "Install Kube-Prometheus-Stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#helm repo update
kubectl create namespace kube-prometheus-stack || true
helm upgrade --install --wait -n kube-prometheus-stack prometheus prometheus-community/kube-prometheus-stack  --debug
#    -f values-kube-prometheus-stack.yaml


echo "http://loki-loki-distributed-gateway.loki"
echo ""
echo "Install Microservices deployment Loki"
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace loki || true
access_key_id=$(terraform output --raw yandex_storage_bucket_loki_access_key)
export access_key_id
secret_access_key=$(terraform output --raw yandex_storage_bucket_loki_secret_key)
export secret_access_key
bucket=$(terraform output --raw yandex_storage_bucket_loki_bucket)
export bucket
helm upgrade --install --wait loki grafana/loki-distributed -n loki \
    --set "loki.storageConfig.aws.access_key_id=$access_key_id"  \
    --set "loki.storageConfig.aws.secret_access_key=$secret_access_key"  \
    --set "loki.storageConfig.aws.bucketnames=$bucket"  \
    -f value-loki-distributed.yaml  --debug


echo ""
echo "Install Promtail"
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace promtail || true
helm upgrade --install --wait promtail grafana/promtail -n promtail --set "loki.serviceName=loki" --version 6.6.2 -f values-promtail.yaml  --debug


echo ""
echo "Install loggenerator"
kubectl create namespace loggenerator || true
helm upgrade --install --wait loggenerator -n loggenerator ./loggenerator --set replicaCount=1  --debug



end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
