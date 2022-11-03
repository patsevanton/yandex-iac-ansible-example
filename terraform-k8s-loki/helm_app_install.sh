#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

# Install Kube-Prometheus-Stack
echo ""
echo "Install Kube-Prometheus-Stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install promgrafana prometheus-community/kube-prometheus-stack -f values-kube-prometheus-stack.yaml
#echo ""
#echo "Print jenkins password"
#kubectl exec --namespace default -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo

end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"