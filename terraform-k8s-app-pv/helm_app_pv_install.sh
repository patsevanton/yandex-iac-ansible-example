#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

#echo ""
#echo "refresh helm cache"
#rm -rf ~/.helm/cache/archive/*
#rm -rf ~/.helm/repository/cache/*

echo ""
echo "Install postgresql"
#helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
#helm repo update
kubectl create namespace postgresql || true
helm upgrade --install --wait -n postgresql postgresql bitnami/postgresql

end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"