#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

# Check command available yc terraform kubectl helm
list_command_available=(yc terraform kubectl helm)

for i in ${list_command_available[*]}
do
    if ! command -v $i &> /dev/null
    then
        echo "$i could not be found"
        exit 1
    fi
done

if yc config list | grep -q 'token'; then
  echo "yc configured. Passed"
else
  echo "yc doesn't configured."
  echo "Please run 'yc init'"
  exit 1
fi

TF_IN_AUTOMATION=1 terraform init -upgrade
TF_IN_AUTOMATION=1 terraform apply -auto-approve
mkdir -p /home/$USER/.kube
terraform output kubeconfig > /home/$USER/.kube/config
sed '/EOT/d' -i /home/$USER/.kube/config

# Создаем  ingress
echo ""
echo "Install Ingress:"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
werf helm upgrade --install --atomic nginx-ingress ingress-nginx/ingress-nginx

# Установка cert-manager
echo ""
echo "Install cert-manager:"
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true
