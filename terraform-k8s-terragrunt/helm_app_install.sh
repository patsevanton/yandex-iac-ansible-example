#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")


mkdir -p "/home/$USER/.kube"
cd master
export cluster_id=$(terragrunt output --raw cluster_id)
echo "$cluster_id"
cd ..
yc managed-kubernetes cluster get-credentials --id "$cluster_id" --external --force

cd vpc-address
export external_ipv4_address=$(terragrunt output --raw external_ipv4_address)
echo "$external_ipv4_address"
cd ..

echo "================Install ingress-nginx======================"
helmfile apply -f helmfile-ingress-nginx.yaml
echo sleep 5
sleep 5
echo "================ Install kube-prometheus-stack ======================"
helmfile apply -f helmfile-kube-prometheus-stack.yaml
echo sleep 5
sleep 5
#echo "================ Install loki-distributed ======================"
#helmfile apply -f helmfile-loki-distributed.yaml
#echo sleep 5
#sleep 5
#echo "================ Install promtail ======================"
#helmfile apply -f helmfile-promtail.yaml
#echo sleep 5
#sleep 5
#echo "================ Install promtail ======================"
#helmfile apply -f helmfile-loggenerator.yaml


end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
