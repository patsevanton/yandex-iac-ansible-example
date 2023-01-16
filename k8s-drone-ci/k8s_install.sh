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

# Создаем  ingress traefik
echo "Install ingress traefik by helm"
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik

# Получение External IP (внешнего IP) Kubernetes сервиса traefik
echo "External IP traefik"
kubectl get services traefik --output jsonpath='{.status.loadBalancer.ingress[0].ip}'
echo ""

# Установка PostgreSQL
# echo "Install PostgreSQL by helm"
# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo update
# helm install postgresql bitnami/postgresql -f postgresql-values.yaml

export external_ip=$(kubectl get services traefik --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
export traefik_url=traefik.$external_ip.sslip.io
echo $traefik_url

end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"