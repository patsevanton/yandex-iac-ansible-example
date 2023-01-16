#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

echo ""
echo "nexus"
helm repo add sonatype https://sonatype.github.io/helm3-charts/
helm repo update
kubectl create namespace nexus || true
helm upgrade --install --wait -n nexus nexus sonatype/nexus-repository-manager -f values-nexus.yaml
#helm upgrade --install --wait -n nexus nexus nexus/nexus --set externalURL=https://nexus.apatsev.org.ru --set expose.ingress.hosts.core=nexus.apatsev.org.ru --set nexusAdminPassword=nexus12345 --set expose.tls.secretName=letsencrypt-prod  --set expose.ingress.annotations="cert-manager.io/cluster-issuer=letsencrypt-prod"


end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"