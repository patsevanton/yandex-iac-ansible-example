#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

echo ""
echo "Install Kube-Prometheus-Stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#helm repo update
kubectl create namespace kube-prometheus-stack || true
helm upgrade --install --wait -n kube-prometheus-stack kube-prometheus-stack \
     prometheus-community/kube-prometheus-stack --version 43.3.1 -f values-kube-prometheus-stack.yaml

echo ""
echo "Install stress"
helm repo add sudermanjr https://charts.sudermanjr.com
#helm repo update
kubectl create namespace stress || true
helm upgrade --install --wait -n stress stress sudermanjr/stress --version 0.2.0 -f values-stress.yaml

end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"