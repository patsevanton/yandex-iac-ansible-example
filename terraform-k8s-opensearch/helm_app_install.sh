#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

echo ""
echo "Install opensearch"
helm repo add opensearch https://opensearch-project.github.io/helm-charts/
helm repo update
werf helm install --wait opensearch opensearch/opensearch --version 2.7.0 --set sysctlInit.enabled=true,replicas=1
werf helm install --wait opensearch-dashboards opensearch/opensearch-dashboards --version 2.5.3


end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo Execution time was $(expr $end_time - $start_time)  s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"