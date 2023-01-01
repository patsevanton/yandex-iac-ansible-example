#!/bin/bash

set -eu pipefail

start_time=`date +%s`
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

#export TF_LOG="TRACE"
TF_IN_AUTOMATION=1 terraform init -upgrade
TF_IN_AUTOMATION=1 terraform apply -auto-approve -no-color 2>&1 | tee terraform.log
mkdir -p /home/$USER/.kube
terraform output kubeconfig > /home/$USER/.kube/config
sed '/EOT/d' -i /home/$USER/.kube/config
export fqdn_sentry_postgres=$(terraform output --raw fqdn_sentry_postgres) || true
echo $fqdn_sentry_postgres
export sentry_postgres_password=$(terraform output --raw sentry_postgres_password) || true
echo $sentry_postgres_password

end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"