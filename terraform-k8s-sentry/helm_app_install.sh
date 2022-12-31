#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

echo ""
echo "Install cert-manager"
helm repo add cert-manager https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager || true
helm upgrade --install --wait -n cert-manager cert-manager cert-manager/cert-manager --set installCRDs=true
kubectl apply -f ClusterIssuer.yaml

echo ""
echo "Install sentry"
helm repo add sentry https://sentry-kubernetes.github.io/charts
helm repo update
kubectl create namespace sentry || true
export fqdn_sentry_redis=$(terraform output --raw fqdn_sentry_redis)
echo $fqdn_sentry_redis
export sentry_redis_password=$(terraform output --raw sentry_redis_password)
echo $sentry_redis_password
#helm show values sentry/sentry
time helm upgrade --install --wait  -n sentry sentry sentry/sentry -f value-sentry.yaml --timeout 10m
#helm install -n sentry sentry sentry/sentry \
#     --set "redis.enabled=false" \
#     --set "externalRedis.host=$fqdn_sentry_redis" \
#     --set "externalRedis.password=$sentry_redis_password"
#helm install sentry ../../sentry-helm-charts/sentry \
#     --set "redis.enabled=false" \
#     --set "externalRedis.host=$fqdn_sentry_redis" \
#     --set "externalRedis.password=$sentry_redis_password"


end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"