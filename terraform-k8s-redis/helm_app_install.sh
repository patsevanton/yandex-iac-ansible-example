#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

echo ""
echo "Install redis"
helm repo add bitnami https://charts.bitnami.com/bitnami
#helm repo update
kubectl create namespace redis || true
helm upgrade --install --wait -n redis redis bitnami/redis --version 17.4.2 -f values-redis.yaml

end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"