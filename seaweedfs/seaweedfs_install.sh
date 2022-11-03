#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")
TF_IN_AUTOMATION=1 terraform init -upgrade
TF_IN_AUTOMATION=1 terraform apply -auto-approve
ansible-galaxy install --force git+https://github.com/bmillemathias/ansible-role-seaweedfs.git,main
ansible-playbook -i host.ini playbook.yml -bK
end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"