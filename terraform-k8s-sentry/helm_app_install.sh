#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

echo ""
echo "Install Sentry"
helm repo add sentry https://sentry-kubernetes.github.io/charts
helm repo update
export fqdn_sentry_redis=$(terraform output --raw fqdn_sentry_redis)
echo $fqdn_sentry_redis
export sentry_redis_password=$(terraform output --raw sentry_redis_password)
echo $sentry_redis_password
#helm template sentry ../../sentry-charts/sentry


end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"