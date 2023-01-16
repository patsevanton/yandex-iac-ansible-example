#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")
TF_IN_AUTOMATION=1 terraform init -upgrade
TF_IN_AUTOMATION=1 terraform apply -auto-approve
ansible-galaxy install geerlingguy.docker
#ansible-galaxy install git+https://github.com/stephane-klein/ansible-role-sentry.git,master
ansible-playbook -i inventory.yml playbook.yml
#export fqdn_sentry_postgres=$(terraform output --raw fqdn_sentry_postgres) || true
#echo $fqdn_sentry_postgres
#export sentry_postgres_password=$(terraform output --raw sentry_postgres_password) || true
#echo $sentry_postgres_password
end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo Execution time was $(expr $end_time - $start_time)  s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"
