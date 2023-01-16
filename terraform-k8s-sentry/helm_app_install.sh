#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

echo ""
echo "Install cert-manager"
helm repo add cert-manager https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager || true
time helm upgrade --install --wait -n cert-manager cert-manager cert-manager/cert-manager --set installCRDs=true
kubectl apply -f ClusterIssuer.yaml

echo ""
echo "Install sentry"
helm repo add sentry https://sentry-kubernetes.github.io/charts
helm repo update
kubectl create namespace sentry || true

fqdn_sentry_postgres=$( terraform output --raw fqdn_sentry_postgres ) || true
export fqdn_sentry_postgres
echo "$fqdn_sentry_postgres"
sentry_postgres_password=$( terraform output --raw sentry_postgres_password ) || true
export sentry_postgres_password
echo "$sentry_postgres_password"
#helm show values sentry/sentry
time helm upgrade --install --wait -n sentry sentry sentry/sentry --timeout 20m
# Check postgres logs
#time helm upgrade --install --wait -n sentry sentry sentry/sentry -f value-sentry.yaml --timeout 20m \
#     --set "externalPostgresql.host=$fqdn_sentry_postgres" \
#     --set "externalPostgresql.password=$sentry_postgres_password"


end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"