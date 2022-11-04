#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

echo ""
echo "Install Kube-Prometheus-Stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f values-kube-prometheus-stack.yaml

# sleep 20
echo "sleep 20"
sleep 20


echo ""
echo "Install cassandra"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create namespace cassandra || true
helm upgrade --install cassandra bitnami/cassandra -n cassandra -f value-cassandra.yaml


echo ""
echo "Install Microservices deployment Loki"
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace loki || true
helm upgrade --install loki grafana/loki-distributed -n loki -f value-loki-distributed.yaml


echo ""
echo "Install Promtail"
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace promtail || true
helm upgrade --install promtail grafana/promtail -n promtail --set "loki.serviceName=loki" -f values-promtail.yaml

echo ""
echo "Install loggenerator"
kubectl create namespace loggenerator || true
helm upgrade --install loggenerator -n loggenerator ./loggenerator

end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"