#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

echo ""
echo "sentry"
helm repo add sonatype https://sonatype.github.io/helm3-charts/
helm repo update
kubectl create namespace sentry || true
helm upgrade --install --wait -n sentry sentry sonatype/sentry-repository-manager -f values-sentry.yaml
#helm upgrade --install --wait -n sentry sentry sentry/sentry --set externalURL=https://sentry.apatsev.org.ru --set expose.ingress.hosts.core=sentry.apatsev.org.ru --set sentryAdminPassword=sentry12345 --set expose.tls.secretName=letsencrypt-prod  --set expose.ingress.annotations="cert-manager.io/cluster-issuer=letsencrypt-prod"


end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"