#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

echo ""
echo "harbor"
helm repo add harbor https://helm.goharbor.io
helm repo update
kubectl create namespace harbor || true
helm upgrade --install --wait -n harbor harbor harbor/harbor --set externalURL=https://harbor.apatsev.org.ru --set expose.ingress.hosts.core=harbor.apatsev.org.ru --set harborAdminPassword=Harbor12345 --set expose.tls.secretName=letsencrypt-prod  --set expose.ingress.annotations="cert-manager.io/cluster-issuer=letsencrypt-prod"


end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"