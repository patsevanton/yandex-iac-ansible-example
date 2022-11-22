#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

echo ""
echo "refresh helm cache"
rm -rf ~/.helm/cache/archive/*
rm -rf ~/.helm/repository/cache/*

echo ""
echo "Install Kube-Prometheus-Stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
werf helm upgrade --install --wait kube-prometheus-stack prometheus-community/kube-prometheus-stack
#    -f values-kube-prometheus-stack.yaml


#echo ""
#echo "Install cassandra"
#helm repo add bitnami https://charts.bitnami.com/bitnami
#helm repo update
#kubectl create namespace cassandra || true
#werf helm upgrade --install --wait cassandra bitnami/cassandra -n cassandra -f value-cassandra.yaml

# Set grafana datasource loki
echo "http://loki-loki-distributed-gateway.loki"
echo ""
echo "Install Microservices deployment Loki"
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace loki || true
#export access_key_id=$(terraform output --raw access_key_sa_storage_admin_for_test_bucket)
#export secret_access_key=$(terraform output --raw secret_key_sa_storage_admin_for_test_bucket)
werf helm upgrade --install --wait loki grafana/loki-distributed -n loki --version 0.65.1

#    --set "loki.storageConfig.aws.access_key_id=$access_key_id"  \
#    --set "loki.storageConfig.aws.secret_access_key=$secret_access_key"  \
#    -f value-loki-distributed.yaml \
#    ../../grafana-helm-charts/charts/loki-distributed


echo ""
echo "Install Promtail"
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace promtail || true
werf helm upgrade --install --wait promtail grafana/promtail -n promtail --set "loki.serviceName=loki" --version 6.6.2 -f values-promtail.yaml

echo ""
echo "Install loggenerator"
kubectl create namespace loggenerator || true
werf helm upgrade --install --wait loggenerator -n loggenerator ./loggenerator --set replicaCount=5

end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"