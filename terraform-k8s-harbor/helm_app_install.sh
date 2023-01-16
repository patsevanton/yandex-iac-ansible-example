#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

echo ""
echo "Install cert-manager"
helm repo add cert-manager https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager || true
 helm upgrade --install --wait -n cert-manager cert-manager cert-manager/cert-manager --set installCRDs=true
kubectl apply -f ClusterIssuer.yaml

echo ""
echo "Install harbor"
helm repo add harbor https://helm.goharbor.io
helm repo update
kubectl create namespace harbor || true
helm upgrade --install --wait -n harbor harbor harbor/harbor -f values-harbor.yaml
#helm upgrade --install --wait -n harbor harbor harbor/harbor --set externalURL=https://harbor.apatsev.org.ru --set expose.ingress.hosts.core=harbor.apatsev.org.ru --set harborAdminPassword=Harbor12345 --set expose.tls.secretName=letsencrypt-prod  --set expose.ingress.annotations="cert-manager.io/cluster-issuer=letsencrypt-prod"


end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"