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


echo "================ Install postgresql ======================"
helmfile apply -f helmfile-postgresql.yaml


end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
